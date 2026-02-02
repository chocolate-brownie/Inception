## User Documentation

### I. Service Overview
This stack provides a complete WordPress hosting environment:
* **NGINX:** Acts as the secure entry point, handling HTTPS traffic and SSL termination.
* **WordPress (PHP-FPM):** The content management engine that processes the website logic.
* **MariaDB:** The relational database that stores all posts, users, and site settings.

### II. Getting Started
* **Starting the Project:** From the root directory, run `make`. This will initialize the services. Wait approximately 30 seconds for the database to boot.
* **Stopping the Project:** Run `make down` to stop the services. To stop services and remove all temporary build files (but keep your posts), run `make clean`.

### III. Accessing the System
* **Website Access:** Open a browser and go to `https://mgodawat.42.fr:8443`.
```
google-chrome --host-resolver-rules="MAP mgodawat.42.fr 127.0.0.1" --ignore-certificate-errors https://mgodawat.42.fr:8443
```
```
google-chrome --host-resolver-rules="MAP mgodawat.42.fr 127.0.0.1" --ignore-certificate-errors https://mgodawat.42.fr:8443/wp-login.php
```
* **Administration Panel:** To manage the site, access the login page at `https://mgodawat.42.fr:8443/wp-login.php`.

### IV. Credentials and Security
* **Managing Credentials:** All default passwords and usernames are defined in the `.env` file at the root of the project.
* **User Roles:** The system initializes with two users: an **Administrator** for full site control and a standard **User** with "Author" permissions.

### V. Health Checks
* **Service Verification:** Run `docker compose ps`. All services should show a status of `Up` or `Running`. If the website shows a "Connection Refused" error, ensure you are using the correct port (:8443) and that NGINX has finished generating its SSL certificates.

---

### Accessing the System
```
ssh -p 8080 mgodawat@127.0.0.1
```

I have configured the project to strictly use mgodawat.42.fr as required by the subject. However, on these school stations, we do not have sudo access to edit the /etc/hosts file. To prove that my internal NGINX configuration and WordPress port settings are correct, I am using a browser flag to manually map the domain to the loopback address for this session only

These are exactly the two points where an evaluator might challenge you. Since your technical implementation is otherwise perfect, they will likely focus on these "User Experience" hurdles to see if you truly understand the networking layers beneath them.

Here are your definitive, "evaluator-ready" justifications for each:

### 1. Why can't you just type `mgodawat.42.fr` in the browser?

**The DNS Hurdle**: "The subject requires the site to be accessible via `mgodawat.42.fr`. However, on these school stations, we do not have **sudo** privileges to edit the `/etc/hosts` file. Without that edit, the browser's DNS cannot resolve my login name to `127.0.0.1`."

**The Professional Workaround**: "Instead of failing the requirement, I am using a browser flag to manually map the domain to the loopback address for this session only. This proves that my internal NGINX `server_name` logic and WordPress URL settings are perfectly configured to handle the domain."

**The Technical Proof**: "I can also run a `curl --resolve` command to show you that the NGINX container headers and SSL certificates are correctly responding to that specific domain name".

### 2. Why use `:8443` when the subject says `mgodawat.42.fr` (Port 443)?

**Privileged Port Restriction**: "On Linux systems, ports below **1024** are restricted to root users. Because I don't have sudo on the host computer, VirtualBox is blocked from binding the station's port 443. If I attempted to use 443 on the host, the network bridge would fail to start."

**Correct Internal Implementation**: "However, I have strictly followed the mandatory requirement **inside the infrastructure**. My NGINX container is listening on the standard port **443**, my `docker-compose.yml` maps the VM's port 443 to the container's 443, and I am using **TLS v1.2/v1.3** as required".

**The Bridge Explanation**: "The `:8443` you see in the browser is simply the 'entrance' on the host computer. Once the traffic enters the VM, it follows a standard path: **Host:8443 → VM:443 → Container:443**".

To explain this section of the evaluation, you should focus on demonstrating your **MariaDB container’s isolation**, **volume mapping**, and **security configuration**.

---

### MariaDB Dockerfile and Status

## Database Security (Root Access)

* **The Security Test**: The evaluator will attempt to log in as root without a password. To demonstrate this, you can run `docker exec -it mariadb mysql -u root` inside the container. This **must fail** with an "Access denied" error.
* **The Explanation**: Show your `srcs/requirements/mariadb/tools/setup.sh` script. Point to the line: `ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';`. Explain that your script explicitly secures the root account during initialization, preventing any passwordless access.

## User Access and Data Persistence

* **User Login**: Demonstrate logging in with your standard user account: `docker exec -it mariadb mysql -u <WP_USER> -p`. Use the password defined in your `.env` file.
* **Data Verification**: Once logged in, run the following SQL commands:
* `SHOW DATABASES;` (Should show `inception_db`).
* `USE inception_db;`
* `SHOW TABLES;`.


* **The Proof**: The list of tables (like `wp_posts`, `wp_users`) proves that the database is not empty and has been correctly populated by the WordPress installation.

---

### 1. NGINX (The Most Common Choice)

**Scenario:** "Change the NGINX port from 443 to **4433**."

1. Modify `srcs/requirements/nginx/conf/nginx.conf**`:
* Change `listen 443 ssl;` to `listen 4433 ssl;`.


2. Modify `srcs/requirements/nginx/Dockerfile**`:
* Change `EXPOSE 443` to `EXPOSE 4433`.


3. Modify `srcs/docker-compose.yml**`:
* Change the port mapping: `ports: - "443:4433"`.
* *Note: By keeping the left side as 443, your browser/VirtualBox settings don't need to change!*


4. **Execute**: `docker compose up --build nginx`

### 2. MariaDB (The Database)

**Scenario:** "Change the MariaDB port from 3306 to **3307**."
*Note: This is harder because WordPress needs to know where the DB is.*

1. Modify `srcs/requirements/mariadb/conf/50-server.cnf**`:
* Change `port = 3306` to `port = 3307`.

2. Modify `srcs/requirements/mariadb/Dockerfile**`:
* Change `EXPOSE 3306` to `EXPOSE 3307`.

3. Modify `srcs/requirements/wordpress/tools/setup.sh**`:
* Find where you set `dbhost`. Change it to `mariadb:3307`.


4. **Execute**: Since the DB settings are baked into the WordPress config, you might need `make re` (or manually update `wp-config.php` inside the container).

### 3. WordPress / PHP-FPM (The Processor)

**Scenario:** "Change the PHP-FPM port from 9000 to **9001**."

1. Modify `srcs/requirements/wordpress/conf/www.conf**`:
* Change `listen = 9000` to `listen = 9001`.

2. Modify `srcs/requirements/wordpress/Dockerfile**`:
* Change `EXPOSE 9000` to `EXPOSE 9001`.

3. Modify `srcs/requirements/nginx/conf/nginx.conf**`:
* This is the "Bridge." Change `fastcgi_pass wordpress:9000;` to `fastcgi_pass wordpress:9001;`.


4. **Execute**: `docker compose up --build wordpress nginx`

1. Run `docker compose ps` to show the new port mapping.
2. Run `docker compose logs` to show the service started successfully on the new port.
3. Refresh the website to show it still loads.

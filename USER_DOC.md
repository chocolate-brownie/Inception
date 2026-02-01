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

## Developer Documentation

### I. Environment Setup
* **Prerequisites:** This project requires a Virtual Machine running **Debian 11 (Bullseye)**, with **Docker** and the **Docker Compose** plugin installed.
* **Configuration Files:** The project relies on a `.env` file at the root to store sensitive variables (DB passwords, admin credentials). The `srcs/` folder contains the `docker-compose.yml` and the `requirements/` subdirectories for each service's Dockerfile and configuration.
* **Secrets Management:** While basic variables are in `.env`, the project avoids hardcoding passwords in Dockerfiles. During setup, environment variables are passed directly to the scripts to initialize the MariaDB user and WordPress database securely.

### II. Build and Deployment
* **The Makefile:** The `Makefile` at the root automates the entire lifecycle. Running `make` creates the necessary host directories, then calls `docker compose up --build`.
* **Build Commands:** * `make`: Builds and starts all containers in detached mode.
    * `make re`: Performs a `clean` and then rebuilds, useful for applying configuration changes without losing data.

### III. Container Management
* **Maintenance Commands:** * View Logs: `docker logs -f <container_name>`
    * Shell Access: `docker exec -it <container_name> /bin/bash`
    * Status: `docker compose ps`
* **Network Architecture:** All containers are connected via a dedicated bridge network named `inception_net`. This provides internal DNS (services can find each other by name, e.g., `mariadb:3306`) while isolating the database from external host access.

### IV. Data Persistence and Volumes
* **Storage Location:** All persistent data is stored on the host machine at `/home/mgodawat/data/mariadb` and `/home/mgodawat/data/wordpress`.
* **Persistence Logic:** By using Docker **Bind Mounts**, the internal container paths are mapped directly to these host folders. Even if the containers are removed or the images are pruned, the data remains on the SSD and is re-attached when the containers restart.

---

### 1. Infrastructure Automation (Makefile)

The evaluator will start by asking you to build the project using your **Makefile**.

* **`make`**: Builds and starts all containers in the background.
* **`make down`**: Stops and removes the containers without deleting your data.
* **`make clean`**: Stops the project and performs a standard system prune to remove unused objects.
* **`make fclean`**: The "nuclear" option. It stops the project and deletes the persistent data in `/home/mgodawat/data`.
* **`make re`**: Performs a `clean` followed by `all` to rebuild the stack.

### 2. Status and Logs

Use these to prove your containers are "Up" and to show the logic in your setup scripts.

* **`docker compose ps`**: Shows the status of all services. Evaluators look for the `Up` status.
* **`docker compose logs -f`**: Streams logs for all services. Useful for showing the "MariaDB is up!" synchronization.
* **`docker logs <container_name>`**: Shows logs for a specific container (e.g., `docker logs wordpress`) to prove idempotency.

### 3. Container Interrogation

The evaluator might ask you to enter a container to verify files or database content.

* **`docker exec -it <container_name> /bin/bash`**: Opens an interactive terminal inside the specified container.
* 
**`mariadb -u <user> -p`**: (Inside the MariaDB container) Used to log in and show that the database is not empty.


* **`ls -la /var/www/html`**: (Inside the WordPress container) Proves the WordPress files exist and have the correct permissions.

### 4. Volume and Network Verification

The evaluation sheet specifically requires checking these Docker objects.

* **`docker network ls`**: Lists all networks. You must show that `inception_net` exists.


* 
**`docker volume ls`**: Lists all volumes.


* **`docker volume inspect <volume_name>`**: Shows the details of a volume. The evaluator will look for the host path `/home/mgodawat/data/`.



### 5. Connectivity and Security Proofs

Use these to demonstrate that your port mapping and domain logic are correct on restricted school stations.

* **`curl -I -k --resolve mgodawat.42.fr:8443:127.0.0.1 https://mgodawat.42.fr:8443`**: Proves that NGINX and WordPress are correctly responding to your domain name, even without `sudo` access to `/etc/hosts`.
* **`google-chrome --host-resolver-rules="MAP mgodawat.42.fr 127.0.0.1" --ignore-certificate-errors`**: Launches a browser session that correctly maps your domain to localhost, allowing you to bypass school cluster DNS restrictions.
* 
**`netstat -tuln`**: Can be used to show which ports are listening on the machine to prove port 80 is not active.



### 6. The "Emergency Reset"

The evaluation sheet provides this command for the evaluator to run before starting to ensure a clean environment:

* 
`docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null`.

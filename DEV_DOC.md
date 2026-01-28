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

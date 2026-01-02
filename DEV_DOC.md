## Developer Documentation

This file focuses on the **underlying architecture** and **environment setup**.

### I. Environment Setup

*
**Prerequisites:** List the tools needed before building (e.g., Docker, Docker Compose, and a Virtual Machine).


*
**Configuration Files:** Explain the purpose of the `.env` file and the `srcs` folder structure.


*
**Secrets Management:** Describe how the project handles sensitive data using Docker Secrets rather than hardcoded passwords.



### II. Build and Deployment

*
**The Makefile:** Explain how the `Makefile` automates the `docker-compose.yml` build process.


*
**Build Commands:** List the commands used to build images from scratch using the custom Dockerfiles.



### III. Container Management

*
**Maintenance Commands:** Provide relevant commands for a developer to inspect logs, enter a container shell, or check network status.


*
**Network Architecture:** Describe the internal Docker network that connects the containers while keeping them isolated from the host.



### IV. Data Persistence and Volumes

*
**Storage Location:** Identify the specific path on the host machine (`/home/login/data`) where the volumes are stored.


*
**Persistence Logic:** Explain how the database and website files persist even if the containers are removed.



---

### Mandatory Checklist for Both Documents

* Both files must be in **Markdown (.md)** format.


* Both files must be located at the **root** of your repository.
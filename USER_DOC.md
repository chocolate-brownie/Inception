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
* **Administration Panel:** To manage the site, access the login page at `https://mgodawat.42.fr:8443/wp-login.php`.

### IV. Credentials and Security
* **Managing Credentials:** All default passwords and usernames are defined in the `.env` file at the root of the project.
* **User Roles:** The system initializes with two users: an **Administrator** for full site control and a standard **User** with "Author" permissions.

### V. Health Checks
* **Service Verification:** Run `docker compose ps`. All services should show a status of `Up` or `Running`. If the website shows a "Connection Refused" error, ensure you are using the correct port (:8443) and that NGINX has finished generating its SSL certificates.

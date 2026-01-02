*This project has been created as part of the 42 curriculum by mgodawat. Its an exercise to broaden system administrative skills of the student using Docker.*

## 1. Description
The goal of this project is to create a secure, automated web-hosting environment using **Docker**. My infrastructure follows a **microservices-oriented architecture** where each component is isolated.

**Microservices-oriented architecture** is a design style where a single application is built using small independent components. Each of these components run its own processes and communicate with others using lightweight mechanism, typically an API (like HTTP/REST) So instead of building one giant application where everything is mixed together, we can break the system into small independent pieces and make them work together.

The technology that creates these independent containers known as **Docker**. Its a lightweight "isolated box" that holds only what necessary for that specific service to run



At the front, I have configured **NGINX** to act as a secure gateway, accepting only encrypted traffic via **TLSv1.2/v1.3**. This gateway communicates internally with a **Wordpress** container (powered by php-fpm) and **MariaDB** database.





## 2. Project Design Choices & Technical Comparisons

This is a critical section for your peer evaluations. You must provide a clear comparison and justify your choices for the following:

*
**Virtual Machines vs. Docker:** What are the fundamental differences in how they handle resources and isolation?


*
**Secrets vs. Environment Variables:** Why is it mandatory to use secrets for passwords instead of just `.env` files or Dockerfiles?


*
**Docker Network vs. Host Network:** Why is `network: host` forbidden in this project, and how does the internal Docker network improve security?


*
**Docker Volumes vs. Bind Mounts:** Explain the difference in how data is managed and why volumes were chosen for WordPress and MariaDB.



## 3. Instructions

*
**Compilation/Build:** Explain the role of your `Makefile` and how it interacts with `docker-compose.yml` to build images from your `Dockerfiles`.


*
**Installation:** Are there any prerequisites needed on the host Virtual Machine before running the project?


*
**Execution:** Provide the exact commands to start and stop the entire infrastructure.



## 4. Resources & AI Usage

*
**References:** List the documentation, articles, or tutorials you used (e.g., Docker or NGINX official docs).


*
**AI Disclosure:** * Which specific Al tools did you use?


* For which specific tasks and parts of the project was Al utilized?


* How did you verify that the Al-generated content was accurate and secure?





---

### Peer Discussion Checklist

When you are explaining your project to your peers, be prepared to answer these "why" questions based on the subject's rules:

1.
**Isolation:** Why must NGINX, WordPress, and MariaDB be in separate containers?


2.
**OS Choice:** Why did you choose Alpine or Debian, and why is the "latest" tag forbidden?


3.
**Entrypoint:** Why is the NGINX container the only allowed entry point (port 443)?


4.
**PID 1:** How did you ensure your containers don't run on infinite loops like `sleep infinity`?
*This project has been created as part of the 42 curriculum by mgodawat. Its an exercise to broaden system administrative skills of the student using Docker.*

## 1. Description
The goal of this project is to build a web-hosting service. We have a functional dynamic website powered by WordPress and we need a place for this website to sit and listen until a user calls for it from their browser.

Web hosting service will contains all the technologies that will serve to function the website properly and those are **WordPress, php-fpm(engine required by WordPress), MariaDB(database), NGINX(A web server that acts as a secure gatekeeper)**

The web hosting service will be built on a **virtual machine** as the bass layer. Of course we gonna be needing an OS to run in out virtual machine and that will be in my case **Debian**. After that we have to install **Docker** which will help us to put pack all the technologies I mentioned above that we need for to run the website into containers. We can talk about this more later.

![alt text](/assests/img1.png "Inception")

## 2. Project Design Choices & Technical Comparisons

**Virtual Machines vs. Docker**
Virtual machines virtualizes the hardware while docker virtualizes the operating system.
Docker is lightweight and fast compared to virtual machines.

Since docker is virtualizing the application layer of the OS (while vm is doing both os kernel and application layer) it is significantly faster compared to the vms. Docker uses its host os as a bass and able to create these things called **containers** where each container is its own thing as far as it concerns and each container that exist on top of the docker engine do not know about each other. This makes the containers very quarantine and they do not clash with each other whatsoever. Here's a simple diagram to demonstrate my understanding further.

![alt text](/assests/img2.png "VM vs Docker")

**Secrets vs. Environment Variables:** Why is it mandatory to use secrets for passwords instead of just `.env` files or Dockerfile?

**Docker Network vs. Host Network:** Why is `network: host` forbidden in this project, and how does the internal Docker network improve security?

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

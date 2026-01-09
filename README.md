*This project has been created as part of the 42 curriculum by mgodawat. Its an exercise to broaden system administrative skills of the student using Docker.*

## 1. Description
![alt text](/assests/img1.png "Inception")
The goal of this project is to build a web-hosting service. We have a functional dynamic website powered by WordPress and we need a place for this website to sit and listen until a user calls for it from their browser.

Web hosting service will contains all the technologies that will serve to function the website properly and those are **WordPress, php-fpm(engine required by WordPress), MariaDB(database), NGINX(A web server that acts as a secure gatekeeper)**

The web hosting service will be built on a **virtual machine** as the base layer. Of course we gonna be needing an OS to run in out virtual machine and that will be in my case **Debian**. After that we have to install **Docker** which will help us to put pack all the technologies I mentioned above that we need for to run the website into containers. We can talk about this more later.


## 2. Project Design Choices & Technical Comparisons

**Virtual Machines vs. Docker**
![alt text](/assests/img2.png "VM vs Docker")
Virtual machines virtualizes the hardware while docker virtualizes the operating system.
Docker is lightweight and fast compared to virtual machines.

Since docker is virtualizing the application layer of the OS (while vm is doing both os kernel and application layer) it is significantly faster compared to the vms. Docker uses its host's os as a base and able to create these things called **containers** where each container is its own thing as far as it concerns and each container that exist on top of the docker engine do not know about each other. This makes the containers very quarantine and they do not clash with each other whatsoever. Here's a simple diagram to demonstrate my understanding further.


### Docker Architecture
![alt text](/assests/img3.png "Docker Architecture")
Docker engine is the heart of the heart of the docker platform. It has two components. First component is the **docker daemon (dockerd)** its the process that runs on top of the host os and responsible for managing all the docker components. The second one is CLI tool called **docker client** which allows you interact with the dockerd using the command line. The user can ``build``, ``run``, ``stop`` and manage docker containers. The CLI can talk to the dockerd thanks to something called REST API.

On top of this docker engine we have **docker images**, docker images can be equal to the count of docker containers that we will create so each container have its own docker image. The docker images are the building blocks of the containers. They are read-only templates that contain the application's code, runtime, system tools and other dependencies. It's a snapshot in time. It's like a photo of computer's hard-drive at the exact moment your softwares were installed and configured perfectly. Because it is "immutable" (unchangeable), every time you start a container from that photo, it starts in that exact same perfect state.

Docker images are created with something called a **docker file** each docker image has a docker file which is a text files containing the instructions for building the image layer by layer. Here's an example of how a dockerfile looks like for building a NGINX server container

```dockerfile
# 1. The Foundation: Start with the Debian "floor"
FROM debian:bullseye

# 2. Preparation: Update the system and install NGINX
RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

# 3. Customization: Copy your configuration file into the "room"
COPY conf/nginx.conf /etc/nginx/nginx.conf

# 4. Networking: Tell the engine which "window" to open (HTTPS)
EXPOSE 443

# 5. Execution: The command that keeps the container "awake"
CMD ["nginx", "-g", "daemon off;"]
```

Then we have our **containers** which we can build thanks to our docker images(+docker files). Docker containers are runnable instances of docker images. They encapsulates the application and its dependencies, providing an isolated environment for execution.

We also have another tool called **docker composer** which lives outside the of the docker engine (it's the thing I have drawn as a stripped blue box) even though its not a part of the main docker engine its essential to the orchestral of the docker engine. Its a tool that lives on our host OS (in our case debian) and acts as the mission commander for the entire project. Using the ``docker-compose.yml``(instructions) it can instructs the containers on how they should act, whether they should run, build stop or do whatever.

### Secrets vs. Environment Variables

**Why is it mandatory to use secrets for passwords instead of just `.env` files or Dockerfile?**

`.env` (metadata) files are part of the container's configuration. Anyone with access to the docker engine can see them in plain text just by "inspecting (`docker inspect`)" the container. Inside the container any process can often see the environmental variables of the other processes. If one small part of your system is hacked, the attacker can simply check the "environment" of the running processes to steal your password. Also if your application crashes, the system often "dumps" all environment variables into a log file to help with debugging, accidentally writing your password onto the disk in a non-secure location.

Also Dockerfiles are built in layers. Every command you write is baked into a read-only layer. Even if you try to delete a password in a later step, it remains permanently stored in the image history. Anyone with the image can run `docker history <image name>` and see exactly what was written in the previous layers. So using `ENV` and `ARG` for storing sensitive data is a NO-GO!

The solution is **Docker secrets** (memory-only files). It is specifically designed and managed by the docker engine to store sensitive information (database passwords, SSH keys etc) outside of your application's images and source code. Secrets are not stored as environment variables. Instead, they are mounted as temporary files at `/run/secrets/<secret_name>`. These files live only in the container's RAM; they are never written to the physical hard drive and disappear the moment the container stops

### Docker Network vs. Host Network

**Why is `network: host` forbidden in this project, and how does the internal Docker network improve security?**

`network: host` is forbidden because it breaks the fundamental goal of the project: creating a secure, tiered architecture. The reason is whe you use `network: host`, the container does not get its own IP address or isolated network space. Instead **it sits directly on the host's network**

The "Internal Docker Network" creates a virtual, private "LAN" where our containers can talk to each other while remaining completely invisible to the host's network and the internet. Instead of each container being on its own "little" network, they share one private internal network so they can communicate. Only NGINX has a specific "door" (Port 443) opened to the host; the other containers stay hidden inside this private space where they are protected from direct attacks.

**Docker Volumes vs. Bind Mounts:** Explain the difference in how data is managed and why volumes were chosen for WordPress and MariaDB.

## 3. Instructions

*
**Compilation/Build:** Explain the role of your `Makefile` and how it interacts with `docker-compose.yml` to build images from your `Docker files`.


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

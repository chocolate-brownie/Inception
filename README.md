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
![alt text](/assests/img4.png "Secrets vs Environmental Variables")
**Why is it mandatory to use secrets for passwords instead of just `.env` files or Dockerfile?**

`.env` (metadata) files are part of the container's configuration. Anyone with access to the docker engine can see them in plain text just by "inspecting (`docker inspect`)" the container. Inside the container any process can often see the environmental variables of the other processes. If one small part of your system is hacked, the attacker can simply check the "environment" of the running processes to steal your password. Also if your application crashes, the system often "dumps" all environment variables into a log file to help with debugging, accidentally writing your password onto the disk in a non-secure location.

Also Dockerfiles are built in layers. Every command you write is baked into a read-only layer. Even if you try to delete a password in a later step, it remains permanently stored in the image history. Anyone with the image can run `docker history <image name>` and see exactly what was written in the previous layers. So using `ENV` and `ARG` for storing sensitive data is a NO-GO!

The solution is **Docker secrets** (memory-only files). It is specifically designed and managed by the docker engine to store sensitive information (database passwords, SSH keys etc) outside of your application's images and source code. Secrets are not stored as environment variables. Instead, they are mounted as temporary files at `/run/secrets/<secret_name>`. These files live only in the container's RAM; they are never written to the physical hard drive and disappear the moment the container stops

### Docker Network vs. Host Network
![alt text](/assests/img5.png "Docker Network vs Host Network")
**Why is `network: host` forbidden in this project, and how does the internal Docker network improve security?**

`network: host` is forbidden because it breaks the fundamental goal of the project: creating a secure, tiered architecture. The reason is whe you use `network: host`, the container does not get its own IP address or isolated network space. Instead **it sits directly on the host's network**

The "Internal Docker Network" creates a virtual, private "LAN" where our containers can talk to each other while remaining completely invisible to the host's network and the internet. Instead of each container being on its own "little" network, they share one private internal network so they can communicate. Only NGINX has a specific "door" (Port 443) opened to the host; the other containers stay hidden inside this private space where they are protected from direct attacks.

### Docker Volumes vs. Bind Mounts
![alt text](/assests/img6.png "Docker Volumes vs Bind Mounts")
**Explain the difference in how data is managed and why volumes were chosen for WordPress and MariaDB**

With **Bind Mounts** the database files are stored in a specific location on host. We might accidentally delete them during a clean up, other programs on our host can access and modify them and backing up means copying that exact folder structure.

```dockerfile
docker run -v /home/mgodawat/data:/var/www/html wordpress
```
Left side `/home/mgodawat/data` is the exact path on YOUR computer. Right side `/var/www/html` is the path inside the container. Docker just creates a tunnel between these two exact locations. The problem is if you give this to a friend, their computer doesn't have `/home/mgodawat/data`

**Docker Volumes** in the other hand would be something like this where docker decides where to actually store the data instead we manually doing it. Since docker manages them its portable and can work anywhere. With Docker volumes we can easily creates backups, other programs on your host cant accidentally mess with them.

```dockerfile
docker volume create wp_data
docker run -v wp_data:/var/www/html wordpress
```

So in simple terms bind mounts are like fixing storage to a specific location, while volumes are like having a managed storage service.

So to answer the question lets imagine a scenario where our wordpress site gets 10,000 visitors and the database needs optimization. As a system administrator we would have to

* Easily migrate the database to faster storage
* Set up automated backups
* Monitor disk usage
* Apply security permissions

With a simple bind mount `/home/mgodawat/data/mariadb` we would have to use traditional linux tools for everything, manually handle permissions, write custom backups With docker volume `mariadb_data` you can `docker volume inspect mariadb_data to see usage`, use Docker's backup utilities, change storage drivers without touching your app and let Docker handle UID/GID mapping

## 3. Instructions

### Compilation/Build

**Explain the role of your `Makefile` and how it interacts with `docker-compose.yml` to build images from your `Docker files`.**

Compilation and built relationship would look something like,
`Makefile` → calls → `docker-compose.yml` → builds from → `Dockerfiles`

`make` is a general build/task automation tool driven by a Makefile. While `docker-compose` is specifically about creating and starting docker containers define in the `docker-compose.yml` file.

`make` executes the targets in the Makefile, which can invoke `docker compose` commands that parse the `docker-compose.yml` to build images from Dockerfiles and start containers

* Makefile: Acts as the project's command center, providing consistent, memorable commands (make, make clean, make re)
* docker-compose.yml: Defines the multi-container architecture and their relationships
* Dockerfiles: Provide service-specific build instructions for each container

Example makefile structure
```Makefile
all:			up		# Default: build and start everything

build:
	@docker-compose -f srcs/docker-compose.yml build --no-cache

up:
	@docker-compose -f srcs/docker-compose.yml up -d

down:
	@docker-compose -f srcs/docker-compose.yml down

clean:			down	# Stop and remove containers
	@docker system prune -af --volumes
	@sudo rm -rf /home/mgodawat/data/*

re:				clean all	# Complete rebuild
```

### Installation

We would be needing these prerequisites before the execution.

* Virtual Machine: Debian 11 (Bullseye)
* Docker: Version 20.10.0 or higher
* Docker Compose: Version 1.29.0 or higher (v2 recommended)
* System Resources:
    * 2+ GB RAM
    * 10+ GB disk space
    * 2 CPU cores minimum
* Network Configuration:
    * Domain name resolution (add to /etc/hosts)
    * Port 443 available

### Execution

``` bash
git clone <your-repo>
cd inception
cp .env.example .env  # Edit with your values

# Start
make  # or make up

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop
make down
```

## 4. Resources & AI Usage

**References:**

* [Virtual Machine (VM) vs Docker - IBM Technology](https://www.youtube.com/results?search_query=understand+docker+ibm)

* [you need to learn Docker RIGHT NOW!! // Docker Containers 101](https://youtu.be/eGz9DS-aIeY?si=yoD2WB5IEzWDwQuS)

* [Docker Crash Course for Absolute Beginners [NEW]](https://www.youtube.com/watch?v=pg19Z8LL06w&t=174s)

**AI Disclosure:**

In this project I have used Gemini for breaking down the project into different parts and what kind of concepts I should learn about building plans and to-do lists to have a clear vision of what I should.

Then I use DeepSeek to research about these topics in advance and use it as a cs-tutor. I like its logical approach when learning computer science related things. I would use Perplexity as an alternative to Google to read documentations or find them since we can trace the sources it finds information from and to confirm the ligeitamicy of the information that is given to me by other tools.

In addition I used these tools to build the backbone structure of these documentation and propose me questions and to write them in advance so I can tackle one problem at a time and write the answers in my own words while doing research.

I used Excalidraw to take notes as in infinite canvas style to draw diagrams and understand, I used Gemini's nano-banana to generate some pictures as well.

---
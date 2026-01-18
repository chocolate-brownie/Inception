# Project variables
NAME		= inception
SRCS		= ./srcs/docker-compose.yml
DATA_PATH	= /home/mgodawat/data

# Default target: builds and starts the containers
all: build
	@printf "Launching configuration ${NAME}...\n"
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@docker compose -f $(SRCS) up -d

# Build images from Dockerfiles
build:
	@printf "Building configuration ${NAME}...\n"
	@docker compose -f $(SRCS) build

# Stop and remove containers
down:
	@printf "Stopping configuration ${NAME}...\n"
	@docker compose -f $(SRCS) down

# Full cleanup: removes containers, images, and volumes
clean: down
	@printf "Cleaning configuration ${NAME}...\n"
	@docker system prune -af
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*

# Complete reset and rebuild
re: clean all

.PHONY: all build down clean re

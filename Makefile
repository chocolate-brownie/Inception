NAME        = inception
SRCS        = ./srcs/docker-compose.yml
DATA_PATH   = /home/mgodawat/data

all:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@docker compose -f $(SRCS) up -d --build

down:
	@docker compose -f $(SRCS) down

# Standard clean: Stops containers but KEEPS data
clean: down
	@docker system prune -af

# Full clean: DELETES data (Use only when resetting project)
fclean: clean
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*

# Rebuilds containers without deleting database
re: clean all

.PHONY: all down clean fclean re

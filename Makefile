# Executables (local)
DOCKER_COMP = docker-compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php-fpm

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start down logs sh composer vendor sf cc

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————

build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

start: build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

bash: ## Open bash terminal
	@$(PHP_CONT) bash

## —— Composer 🧙 ——————————————————————————————————————————————————————————————

composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

cinstall:
	@$(COMPOSER) install --prefer-dist --no-progress --no-scripts --no-interaction

ccreate:
	@$(COMPOSER) create-project symfony/website-skeleton . --no-interaction

create-cache-dir:
	@$(PHP) -r "mkdir('var/cache/dev', 0777);"

create:
	@make up
	@make ccreate
	@make cinstall
#	@mkdir -p var var/cache var/log
#	@chmod -R 777 var
	@#chown -R $(shell id -u):$(shell id -g) var
	@echo "Project installed successfully"

## —— Complete Install 🎵 ———————————————————————————————————————————————————————————————

install: create

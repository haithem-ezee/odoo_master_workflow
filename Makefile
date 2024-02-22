
##############################
#	VARIABLES
BUILD_ACTION=build
UP_ACTION=up -d
DOWN_ACTION=down
COMPOSE_CMD=docker-compose -f
COMPOSE_FILE=docker-compose.yml
ENV_FILE_CMD=--env-file
#ENV_FILE=final.env

##############################
#	GENERAL

.PHONY: list clean code_update init set_env up down deploy 


 list:
	@echo "-----------------------------------------------------------------------------"
	@echo "-------------			ACTIONS				-------------"
	@echo "-----------------------------------------------------------------------------"
	@echo "-------------			GENERAL				-------------"
	@echo ""
	@echo "list :		List all available actions"
	@echo "clean :		Remove unused docker images"
	@echo "code_update :		repositories updates"
	@echo "set_env :		environment configuration"
	@echo "init :		Get last version and initilize envrionement"
	@echo ""
	@echo "-------------			BUILD				-------------"
	@echo ""
	@echo "build :	Build last version of all specified environment"
	@echo ""
	@echo "-------------			UP				-------------"
	@echo ""
	@echo "up :	Build and up components"
	@echo ""
	@echo "-------------			DOWN				-------------"
	@echo ""
	@echo "down :	Down all components"
	@echo ""
	@echo "-------------			DEPLOY				-------------"
	@echo ""
	@echo "deploy :	Updates and deploy all components"
	@echo ""
	@echo ""

clean: 
	@docker image prune --all -f
	@echo "==================================================="
	@echo "--->	Images pool cleaned"
	@echo "==================================================="

code_update:
	@chmod 400 ezee_id_rsa
	@eval $(ssh-agent -s) && ssh-add ezee_id_rsa
	@git fetch
	@git reset --hard HEAD
	@git clean -fxd
	@echo "==================================================="
	@echo "--->	Folder changes removed"
	@echo "==================================================="

	@git pull
	@cd ../devops-* && git fetch && git pull && cd -
	@eval $(ssh-agent -k)
	@echo "==================================================="
	@echo "--->	Last code version is updated"
	@echo "==================================================="

set_env:
	@cp ../devops-*/* .
	@echo "==================================================="
	@echo "--->	File copied to current directory"
	@echo "==================================================="

	@bash extra_addons_management.sh
	@echo "==================================================="
	@echo "--->	Extra addons updated"
	@echo "==================================================="

	@bash environment_variable_managment.sh
	@echo "==================================================="
	@echo "--->	environment variable managment overrided"
	@echo "==================================================="

	@bash override.sh
	@echo "==================================================="
	@echo "--->	files overrided"
	@echo "==================================================="
	
init : code_update set_env	
##############################
# BUILD
##########
build: init
	@$(COMPOSE_CMD) $(COMPOSE_FILE) $(ENV_FILE_CMD) $(ENV_FILE) $(BUILD_ACTION)
	
	@echo "==================================================="
	@echo "--->	Build containers succeed"
	@echo "==================================================="

##############################
# UP
##########
up:
	@$(COMPOSE_CMD) $(COMPOSE_FILE) $(ENV_FILE_CMD) $(ENV_FILE) $(UP_ACTION)
	@echo "==================================================="
	@echo "--->	Up containers succeed"
	@echo "==================================================="

deploy: build up clean
	@echo "==================================================="
	@echo "--->	Environment containers deployed successfully"
	@echo "==================================================="


##############################
# DOWN
##########
down:
	@$(COMPOSE_CMD) $(COMPOSE_FILE) $(ENV_FILE_CMD) $(ENV_FILE) $(DOWN_ACTION)
	@echo "==============================================="
	@echo " Environment containers downed successfully"
	@echo "==============================================="


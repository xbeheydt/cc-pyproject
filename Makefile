# Copyright Xavier Beheydt. All rights reserved.

ENV_DIR				?= .env
SCRIPTS_DIR			?= scripts
PYSCRIPT_PRINT_HELP	= ${SCRIPTS_DIR}/makefile_help.py

ifeq (${OS}, Windows_NT)

RM					= -powershell -Command \
			  		  rm -Force -Confirm:$$false -Recurse -EA Ignore
PREFIX_ENV			= $(ENV_DIR)/Scripts
PYTHON_CACHE_DIR	= $$(ls -Recurse -Directory -Filter __pycache__).FullName

else # Linux / Unix / macOS

RM					= rm -fr
PREFIX_ENV			= $(ENV_DIR)/bin
PYTHON_CACHE_DIR	= $$(find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)")

endif

PYTHON				?= python3
PIP					?= pip
COOKIECUTTER		?= cookiecutter
CC_OPTIONS			?=--no-input

.PHONY: all
all: ## Run all recipes
	${PREFIX_ENV}/$(COOKIECUTTER) ${CC_OPTIONS} . --override-if-exists

.PHONY: configure
configure: mkenv instal ## Configure project

.PHONY: clean
clean: ## Remove all generated files

.PHONY: fclean
fclean: ## Remove all generated files
	$(RM) ${ENV_DIR}

.PHONY: re
re: fclean all ## Remake all

.PHONY: mkenv
mkenv: .env ## Make a virtual environment
.env:
	$(PYTHON) -m venv ${ENV_DIR}
	${PREFIX_ENV}/$(PYTHON) -m $(PIP) install --upgrade pip

.PHONY: install
install: ## Install requirements dependencies
	${PREFIX_ENV}/$(PIP) install -r requirements-dev.txt

.PHONY: help
help: ## Print helps
	@echo Usage: make [target]
	@$(PYTHON) "${PYSCRIPT_PRINT_HELP}" "${CURDIR}/Makefile"

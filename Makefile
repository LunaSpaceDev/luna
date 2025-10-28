### Defensive settings for make:
#     https://tech.davis-hansson.com/p/make/
SHELL:=bash
.ONESHELL:
.SHELLFLAGS:=-eu -o pipefail -c
.SILENT:
.DELETE_ON_ERROR:
MAKEFLAGS+=--warn-undefined-variables
MAKEFLAGS+=--no-builtin-rules

CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Recipe snippets for reuse

# We like colors
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

GIT_FOLDER=$(CURRENT_DIR)/.git

PLONE_VERSION=6
DOCKER_IMAGE=plone/server-dev:${PLONE_VERSION}
DOCKER_IMAGE_ACCEPTANCE=plone/server-acceptance:${PLONE_VERSION}

ADDON_NAME='@lunaspace/luna'

.PHONY: help
help: ## Show this help
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

# Dev Helpers

.PHONY: install-backend
install-backend: ## Installs Plone Backend in a development environment
	${MAKE} -C ./backend/ install
	${MAKE} -C ./backend/ create-site

.PHONY: install-frontend
install-frontend: ## Installs Plone Frontend/Volto in a development environment
	${MAKE} -C ./frontend/ install

.PHONY: install-seven
install-seven: ## Installs Plone Frontend/Seven in a development environment
	@echo "$(GREEN)Install Seven$(RESET)"
	pnpm dlx mrs-developer missdev --no-config --fetch-https
	pnpm i
	make build-deps

.PHONY: install
install: ## Installs Plone Backend, Frontend Volto and Seven in a development environment
	${MAKE} install-backend
	${MAKE} install-frontend
	${MAKE} install-seven

.PHONY: start-backend
start-backend: ## Starts Plone Backend for development
	${MAKE} -C ./backend/ start


.PHONY: start-frontend
start-frontend: ## Starts Volto on port 4000
	PORT=4000 ADDONS=@plone-collective/fortytwo ${MAKE} -C ./frontend/ start

PHONY: start-volto
start-volto: ## Starts Volto on port 3000
	${MAKE} -C ./frontend/ start

.PHONY: start-seven
start-seven: ## Starts Seven on port 3000
	pnpm start

.PHONY: build
build: ## Build a production bundle for distribution of the project with the add-on
	pnpm build

core/packages/registry/dist: $(shell find core/packages/registry/src -type f)
	pnpm --filter @plone/registry build

core/packages/components/dist: $(shell find core/packages/components/src -type f)
	pnpm --filter @plone/components build

core/packages/client/dist: $(shell find core/packages/client/src -type f)
	pnpm --filter @plone/client build

core/packages/providers/dist: $(shell find core/packages/providers/src -type f)
	pnpm --filter @plone/providers build

core/packages/helpers/dist: $(shell find core/packages/helpers/src -type f)
	pnpm --filter @plone/helpers build

core/packages/react-router/dist: $(shell find core/packages/react-router/src -type f)
	pnpm --filter @plone/react-router build

.PHONY: build-deps
build-deps: core/packages/registry/dist core/packages/components/dist core/packages/client/dist core/packages/providers/dist core/packages/react-router/dist core/packages/helpers/dist ## Build dependencies

.PHONY: i18n
i18n: ## Sync i18n
	pnpm --filter $(ADDON_NAME) i18n

.PHONY: ci-i18n
ci-i18n: ## Check if i18n is not synced
	pnpm --filter $(ADDON_NAME) i18n && git diff -G'^[^\"POT]' --exit-code

.PHONY: format
format: ## Format codebase
	pnpm prettier:fix
	pnpm lint:fix
	pnpm stylelint:fix

.PHONY: lint
lint: ## Lint, or catch and remove problems, in code base
	pnpm lint
	pnpm prettier
	pnpm stylelint --allow-empty-input

.PHONY: release
release: ## Release the add-on on npmjs.org
	pnpm release

.PHONY: release-dry-run
release-dry-run: ## Dry-run the release of the add-on on npmjs.org
	pnpm release

.PHONY: test
test: ## Run unit tests
	pnpm test

.PHONY: ci-test
ci-test: ## Run unit tests in CI
	# Unit Tests need the i18n to be built
	VOLTOCONFIG=$(pwd)/volto.config.js pnpm --filter @plone/volto i18n
	CI=1 RAZZLE_JEST_CONFIG=$(CURRENT_DIR)/jest-addon.config.js pnpm --filter @plone/volto test -- --passWithNoTests

.PHONY: backend-docker-start
backend-docker-start:	## Starts a Docker-based backend for development
	@echo "$(GREEN)==> Start Docker-based Plone Backend$(RESET)"
	docker run -it --rm --name=backend -p 8080:8080 -e SITE=Plone $(DOCKER_IMAGE)

## Storybook
.PHONY: storybook-start
storybook-start: ## Start Storybook server on port 6006
	@echo "$(GREEN)==> Start Storybook$(RESET)"
	pnpm run storybook

.PHONY: storybook-build
storybook-build: ## Build Storybook
	@echo "$(GREEN)==> Build Storybook$(RESET)"
	mkdir -p $(CURRENT_DIR)/.storybook-build
	pnpm run storybook-build -o $(CURRENT_DIR)/.storybook-build

## Acceptance
.PHONY: acceptance-frontend-dev-start
acceptance-frontend-dev-start: ## Start acceptance frontend in development mode
	PLONE_API_PATH=http://127.0.0.1:55001/plone pnpm start

.PHONY: acceptance-frontend-prod-start
acceptance-frontend-prod-start: ## Start acceptance frontend in production mode
	pnpm build && PLONE_API_PATH=http://127.0.0.1:55001/plone pnpm start:prod

.PHONY: acceptance-backend-start
acceptance-backend-start: ## Start backend acceptance server
	docker run -it --rm -p 55001:55001 $(DOCKER_IMAGE_ACCEPTANCE)

.PHONY: ci-acceptance-backend-start
ci-acceptance-backend-start: ## Start backend acceptance server in headless mode for CI
	docker run -i --rm -p 55001:55001 $(DOCKER_IMAGE_ACCEPTANCE)

.PHONY: acceptance-test
acceptance-test: ## Start Cypress in interactive mode
	pnpm --filter @plone/tooling exec cypress open --config-file $(CURRENT_DIR)/core/packages/tooling/cypress.config.js --config specPattern=$(CURRENT_DIR)'/cypress/tests/**/*.{js,jsx,ts,tsx}'

.PHONY: ci-acceptance-test
ci-acceptance-test: ## Run cypress tests in headless mode for CI
	pnpm --filter @plone/tooling exec cypress run --config-file $(CURRENT_DIR)/core/packages/tooling/cypress.config.js --config specPattern=$(CURRENT_DIR)'/cypress/tests/**/*.{js,jsx,ts,tsx}'

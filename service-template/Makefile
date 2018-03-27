.DEFAULT_GOAL := help

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MY_DIR)/service-configuration.mk
include $(MY_DIR)/shared-variables.mk

plan-delivery: plan-code-repository plan-pipeline ## See what's involved in setting up the delivery infrastructure

apply-delivery: setup-code-repository setup-pipeline ## Setup each service project's source repo and pipelines

load-delivery: load-new-repo ## Load source code into the service project repositories

destroy-delivery: ## Destroy the source repos and pipelines, but not infrastructure
	-cd pipeline && make destroy
	-cd code-repository && make destroy
	rm -rf infra/.git
	@echo "WARNING: Instances of the infrastructure could still exist"

build: bin/terraform ## Prepare the infrastructure code
	cd infra && make prepare

bin/terraform:
	mkdir -p ./bin
	mkdir -p ./.work
	cd ./.work && curl -LfOs https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip
	unzip .work/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip -d ./bin/

package: local-clean build ## Create a versioned artefact
	mkdir -p ./package
	tar czf ./package/${ARTEFACT_NAME}-${BUILD_VERSION}.tgz \
		--exclude .git \
		--exclude .gitignore \
		--exclude ./pipeline \
		--exclude ./code-repository \
		--exclude ./package \
		--exclude ./.work \
		.

plan: ## Preview infrastructure changes to deployment $(DEPLOYMENT_ID)
	cd infra && make plan

up: ## Provision or update infrastructure for $(DEPLOYMENT_ID)
	cd infra && make up

test: ## Test infrastructure for $(DEPLOYMENT_ID)
	cd infra && make test

destroy: ## Destroy infrastructure for $(DEPLOYMENT_ID)
	-cd infra && make destroy

setup-code-repository:
	cd code-repository && make apply

plan-code-repository:
	cd code-repository && make plan

load-new-repo:
	cd code-repository && make new-repo

plan-pipeline:
	cd pipeline && make plan

setup-pipeline:
	cd pipeline && make apply

local-clean:
	rm -rf ./package ./.work ./bin

clean: local-clean ## Clean local packaging. Does not clean sub-projects
	cd infra && make clean
	cd pipeline && make clean
	cd code-repository && make clean

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

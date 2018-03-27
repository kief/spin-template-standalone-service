.DEFAULT_GOAL := help
.PHONY: test init

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
FUNCTION=pipeline
DEPLOYMENT_ID=delivery
include $(MY_DIR)/../service-configuration.mk
include $(MY_DIR)/../shared-variables.mk

TERRAFORM_VARS=\
	-var "region=$(REGION)" \
	-var "repo_bucket_name=$(ARTEFACT_BUCKET_NAME)" \
	-var "estate_id=$(ESTATE_ID)" \
	-var "component=$(COMPONENT)" \
	-var "service=$(SERVICE)"

init:
	cd ./src && terraform init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=$(STATE_PATH)" \
		-backend-config="region=$(REGION)"

plan: init ## Preview changes without applying them
	cd ./src && terraform plan $(TERRAFORM_VARS)

apply: init ## Create or update infrastructure
	cd ./src && terraform apply -auto-approve $(TERRAFORM_VARS)

test: ## Test the infrastructure
	cd ./test && PIPELINE_NAME=$(SERVICE)-$(COMPONENT)-$(ESTATE_ID)-pipeline ./test-pipeline.sh

vars:
	@echo "$(TERRAFORM_VARS)"

out:
	cd ./src && terraform output $(TERRAFORM_VARS)

destroy: run-destroy clean ## Destroy the infrastructure

run-destroy: init
	cd ./src && terraform destroy -force $(TERRAFORM_VARS)

wreck-all-environments:
	cd ../infra && make destroy DEPLOYMENT_ID=prod

clean: ## Clean local working files
	rm -rf ./src/.terraform ./src/*tfstate*

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

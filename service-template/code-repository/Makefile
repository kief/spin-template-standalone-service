.DEFAULT_GOAL := help
.PHONY: test

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
FUNCTION=code-repository
DEPLOYMENT_ID=delivery
include $(MY_DIR)/../service-configuration.mk
include $(MY_DIR)/../shared-variables.mk

TERRAFORM_VARS=\
	-var "region=$(REGION)" \
	-var "git_ssh_keyfile=$(HOME)/.ssh/git_ssh.pub" \
	-var "estate_id=$(ESTATE_ID)" \
	-var "component=$(COMPONENT)" \
	-var "service=$(SERVICE)"

GIT_CLONE_URL=$(shell cd ./src && terraform output git_ssh_url)
GIT_USERNAME=$(shell cd ./src && terraform output committer_ssh_id)
SSH_CONFIGURED_FOR_CODECOMMIT=$(HOME)/.ssh/ssh_configured_for_codecommit_$(SERVICE)-$(COMPONENT)


init: $(HOME)/.ssh/git_ssh.pub
	cd ./src && terraform init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=$(STATE_PATH)" \
		-backend-config="region=$(REGION)"

plan: init ## Preview changes to the pipeline
	cd ./src && terraform plan $(TERRAFORM_VARS)

apply: init ## Create or update the pipeline
	cd ./src && terraform apply -auto-approve $(TERRAFORM_VARS)

$(HOME)/.ssh/git_ssh.pub:
	ssh-keygen -t rsa -m PEM -b 4096 -C "infra_tester" -N '' -f $(HOME)/.ssh/git_ssh

git-client: $(SSH_CONFIGURED_FOR_CODECOMMIT)
	git config --global user.name "$(GIT_USERNAME)"
	git config --global push.default simple

$(SSH_CONFIGURED_FOR_CODECOMMIT): init
	@echo "" >> $(HOME)/.ssh/config
	echo "# Automatically added by the $(COMPONENT) project" >> $(HOME)/.ssh/config
	echo "Host git-codecommit.*.amazonaws.com" >> $(HOME)/.ssh/config
	@echo "  User $(GIT_USERNAME)" >> $(HOME)/.ssh/config
	@echo "  IdentityFile ~/.ssh/git_ssh" >> $(HOME)/.ssh/config
	@echo "" >> $(HOME)/.ssh/config
	touch $(SSH_CONFIGURED_FOR_CODECOMMIT)

new-repo: git-client copy-source ./build/.git/config ## Import source code into CodeCommit for the first time

./build/.git/config:
	mkdir -p ./build
	cd ./build && git init
	cd ./build && git add .
	cd ./build && git commit -m "Importing source"
	cd ./build && git remote add origin $(GIT_CLONE_URL)
	cd ./build && git push -u origin master

copy-source:
	mkdir -p ./build
	( cd ../ && tar --exclude=code-repository --exclude=.git -cf - . ) | ( cd ./build && tar xf - )

fresh-repo: git-client ## Wipe local build and clone whatever is in CodeCommit
	rm -rf ./build
	git clone $(GIT_CLONE_URL) build

push-fresh: fresh-repo copy-source ## Push local source into CodeCommit
	cd ./build && git add .
	cd ./build && git commit -am "Ran make to bring in changes"
	cd ./build && git push

test: clean-test ## Test the pipeline
	cd ./test && ./check_git_repo.sh $(GIT_CLONE_URL)

clean-test:
	rm -rf ./test/.output

out:
	cd ./src && terraform output

destroy: run-destroy distclean ## Destroy the pipeline

run-destroy: init
	cd ./src && terraform destroy -force $(TERRAFORM_VARS)

clean: clean-test ## Clean local working files
	rm -rf ./src/.terraform ./src/*tfstate* ./build

# TODO: This conflicts with the host & bastion ssh stuff
distclean: clean
	rm -f $(SSH_CONFIGURED_FOR_CODECOMMIT) ~/.ssh/config

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

TERRAFORM_VERSION=0.11.5

DEPLOYMENT_ID?=sandbox

MY_IP=$(shell curl -s icanhazip.com)

AWS_ACCOUNT_ID:=$(shell aws sts get-caller-identity --output text --query Account)
STATE_BUCKET_NAME=$(shell echo "statebucket-$(ESTATE_ID)-$(AWS_ACCOUNT_ID)" | tr '[:upper:]' '[:lower:]' | cut -c 1-63)
STATE_PATH="estate-$(ESTATE_ID)/component-$(COMPONENT)/service-$(SERVICE)/deployment-$(DEPLOYMENT_ID)/$(FUNCTION).tfstate"
ARTEFACT_BUCKET_NAME=$(shell echo repo-$(ESTATE_ID)-$(COMPONENT)-$(SERVICE)-$(AWS_ACCOUNT_ID) | tr '[:upper:]' '[:lower:]' | cut -c 1-63)

ARTEFACT_NAME=$(COMPONENT)-$(SERVICE)
BUILD_VERSION=1.0.$(shell date +%Y%m%d%I%M%S)

BASTION_KEYPAIR_FILE=.work/bastion-keypair-$(COMPONENT)-$(SERVICE)-$(DEPLOYMENT_ID)
WEBSERVER_KEYPAIR_FILE=.work/webserver-keypair-$(COMPONENT)-$(SERVICE)-$(DEPLOYMENT_ID)

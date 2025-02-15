.SHELL := /usr/bin/bash

# ############################################################################################################

export TF_IN_AUTOMATION ?= true
export TF_LOG ?= TRACE
export TF_LOG_PATH ?= /tmp/$(shell basename $$PWD)-$@-$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# ############################################################################################################.PHONY: clear
clear:
	clear

init:
	source .env && \
	cd infrastructure/terraform && \
	terraform init

# Usage: replace % with environment directory name, e.g. for rnd:
# make refresh-rnd
refresh:
	source .env && \
	cd infrastructure/terraform && \
	terraform refresh

# Usage: replace % with environment directory name, e.g. for rnd:
# make plan-rnd
# DEBUG level logs will be written to /tmp/DIRNAME-plan-ENV-TIMESTAMP
plan: init clear
	cd infrastructure/terraform && \
	terraform plan -var-file=bootstrapper.tfvars -out tf-bootstrapper.out

# Usage: replace % with environment directory name, e.g. for rnd:
# make apply-rnd
# DEBUG level logs will be written to /tmp/DIRNAME-apply-ENV-TIMESTAMP
apply: init clear
	cd infrastructure/terraform && \
	terraform apply --auto-approve "tf-bootstrapper.out"

destroy-me: init clear
	cd infrastructure/terraform && \
	terraform destroy --var-file=bootstrapper.tfvars --auto-approve
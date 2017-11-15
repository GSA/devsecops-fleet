TERRAFORM_DIR := terraform
PLAYBOOK_DIR := playbooks
SSH_USER := ec2-user
INVENTORY_PATH := $(shell which terraform-inventory)

all: terraform ansible

install_roles:
	ansible-galaxy install -p roles/external -r requirements.yml

init:
	cd ../$(TERRAFORM_DIR) && terraform init -backend-config="backend.tfvars"

plan:
	cd ../$(TERRAFORM_DIR) && terraform plan

.PHONY: terraform
apply:
	cd ../$(TERRAFORM_DIR) && terraform apply && terraform state pull > terraform.tfstate

.PHONY: ansible
ansible: install_roles init plan apply install_fleet harden_server

debug: install_roles init plan apply install_fleet_debug harden_server

harden_server:
	cd $(PLAYBOOK_DIR) && TF_STATE=../../$(TERRAFORM_DIR)/terraform.tfstate ansible-playbook -i $(INVENTORY_PATH) --become --user=$(SSH_USER) harden_server.yml

install_fleet:
	cd $(PLAYBOOK_DIR) && TF_STATE=../../$(TERRAFORM_DIR)/terraform.tfstate ansible-playbook -i $(INVENTORY_PATH) --become --user=$(SSH_USER) kolide-fleet.yml

install_fleet_debug:
	cd $(PLAYBOOK_DIR) && TF_STATE=../../$(TERRAFORM_DIR)/terraform.tfstate ansible-playbook -i $(INVENTORY_PATH) --become --user=$(SSH_USER) kolide-fleet.yml -step -vvv

destroy:
	cd ../$(TERRAFORM_DIR) && terraform destroy

validate_terraform:
	cd ../$(TERRAFORM_DIR) && terraform validate

validate_ansible:
	cd $(PLAYBOOK_DIR) && ansible-playbook --syntax-check test.yml

validate: validate_terraform validate_ansible

# devsecops-fleet

Kolider/fleet implementation for GSA DevSecOps

This repo will create an implementation of [Kolide Fleet](https://github.com/kolide/fleet/). This is meant to be deployed within an existing GSA DevSecOps deployment. Currently, this repo serves as the deployment for data.gov's implementation.

## Products In Use

* [`terraform/`](terraform/) - [Terraform](https://www.terraform.io/) code for setting up the infrastructure at the [Amazon Web Services (AWS)](https://aws.amazon.com/) level
* [`ansible/`](ansible/) - [Ansible](http://www.ansible.com) to deploy the Jenkins software on the instance (and manage future tools).

## Setup

If you’ve already deployed the DevSecOps-Infrastructure repo, chances are you’ve already done some of this.

1. Set up the AWS CLI on the workstation that will be used to deploy the code.
    1. [Install](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
    1. [Configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
1. Install additional dependencies:
    * [Terraform](https://www.terraform.io/)
    * [Ansible](http://www.ansible.com/)
    * [Terraform-Inventory](https://github.com/adammck/terraform-inventory)

1. Set up the Terraform backend for this deployment. You will need to replace your bucket name with something unique, because bucket names must be unique per-region. If you get an error that the bucket name is not available, then your choice was not unique. Remember this bucket name, you’ll need it later.

    ```sh
    aws s3api create-bucket —bucket <your_unique_bucket_name>
    aws s3api put-bucket-versioning —<your_unique_bucket_name> —versioning-configuration Status=Enabled
    ```

1. Create the Terraform variables file.

    ```sh
    cd terraform
    cp terraform.tfvars.example terraform.tfvars
    cp backend.tfvars.example backend.tfvars
    ```

1. Fill out [`terraform.tfvars`](terraform/terraform.tfvars.example). Mind the variable types and follow the noted rules. Defaults are provided in [`variables.tfvars`](Terraform/variables.tfvars) if you need examples or want to see where values are coming from.

1. Fill out [‘backend.tfvars’](terraform/backend.tfvars.example). The “bucket” parameter *must* match the bucket name you used in the AWS CLI command above, otherwise terraform will throw an error on the init command.

### Ansible Setup

Two quick steps are necessary to keep the ansible side of things happy.

1. Copy the file /ansible/group_vars/devsecops_kolide_eip/vars.yml.example. Name it to "vars.yml" and change the external hostname variable. DO NOT modify the python interpreter variable.

1. Create your server certificate. Name the certificate "fleet.crt" and the private key "fleet.key." Place them in /ansible/playbooks/files.

### Hardening

This repo also uses the GSA ansible role to harden the server according to GSA security baselines. The repo for the hardening is located at [this url](https://github.com/GSA/ansible-os-ubuntu-16/).

Hardening variables can be overridden in the vars.yml file mentioned above. Simply scan the playbooks within the role and set variables in vars.yml according to your specifications if there is a need to override the hardening baselines. This deployment, as configured within source control, should not need to be overriden.

## Deployment

For initial deployment, use the ansible make file to make things easier.

1. Set up environment. For your convenience, terraform commands are provided in the ansible Makefile. If you’re confident in your variable-fu, you can just kick off the “make” command and build the architecture from scratch. This will install all of the necessary roles,

    ```sh
    cd ansible
    make
    ```
This will run all of the commands in order. If you want to break things down into steps, you’re welcome to do them manually:

* make install_roles
* make init
* make plan
* make apply
* make install_fleet
* make harden_server

There is also a “make debug” in the Makefile. This will run all of the steps the same way, except for the last one. It will run “make install_fleet_debug”, which will run ansible in full debug mode. Most problems will occur in variables, so pay careful attention to the variables and the values they expect.

“make destroy” will destroy the environment should you wish. You will have to confirm before it will actually destroys anything.

## Notes

This deployment will automatically install the roles and all dependencies. Those roles will be downloaded during the “make install_roles” phase. The roles will be install in “/ansible/roles/external”.

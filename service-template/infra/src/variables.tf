variable "estate_id" {}
variable "deployment_id" {}
variable "component" {}
variable "service" {}
variable "base_dns_domain" {}

variable "region" { default = "eu-west-1" }
variable "availability_zones" { default = "eu-west-1a,eu-west-1b,eu-west-1c" }
variable "ami" { default = "ami-63b0341a" }

variable "bastion_ssh_key_file" {}
variable "webserver_ssh_key_file" {}

variable "allowed_cidr" {}

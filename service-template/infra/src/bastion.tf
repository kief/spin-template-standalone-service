module "bastion" {
  source                = "github.com/kief/terraform-aws-bastion.git?ref=add_some_tags"
  version               = "~> 0.1"

  region                = "${var.region}"
  vpc_id                = "${module.base-network.vpc_id}"
  subnet_ids            = ["${split(",", module.base-network.private_subnet_ids)}"]

  service               = "${var.service}"
  component             = "${var.component}"
  deployment_identifier = "${var.deployment_id}"
  
  ami                   = "${var.ami}"
  instance_type         = "t2.micro"
  
  ssh_public_key_path   = "${var.bastion_ssh_key_file}"
  
  allowed_cidrs         = ["${split(",", module.base-network.public_subnet_cidr_blocks)}"]
  egress_cidrs          = ["${split(",", module.base-network.private_subnet_cidr_blocks)}"]
  
  load_balancer_names   = ["${module.bastion_load_balancer.name}"]
  
  minimum_instances     = 1
  maximum_instances     = 1
  desired_instances     = 1
}

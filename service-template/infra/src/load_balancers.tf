module "bastion_load_balancer" {
  source                = "infrablocks/classic-load-balancer/aws"
  version               = "~> 0.1"

  region                = "${var.region}"
  vpc_id                = "${module.base-network.vpc_id}"
  subnet_ids            = ["${split(",", module.base-network.public_subnet_ids)}"]
  
  component             = "${var.service}-${var.component}"
  deployment_identifier = "${var.deployment_id}"
  
  domain_name           = "${var.base_dns_domain}"
  public_zone_id        = "${module.dns-zones.public_zone_id}"
  private_zone_id       = "${module.dns-zones.private_zone_id}"
  
  listeners = [
    {
      lb_port           = 22
      lb_protocol       = "TCP"
      instance_port     = 22
      instance_protocol = "TCP"
    }
  ]
  
  access_control = [
    {
      lb_port       = 22
      instance_port = 22
      allow_cidr    = "${var.allowed_cidr}"
    }
  ]
  
  egress_cidrs = ["${split(",", module.base-network.private_subnet_cidr_blocks)}"]
  
  health_check_target               = "TCP:22"
  health_check_timeout              = 10
  health_check_interval             = 30
  health_check_unhealthy_threshold  = 5
  health_check_healthy_threshold    = 5

  enable_cross_zone_load_balancing  = "yes"

  enable_connection_draining        = "yes"
  connection_draining_timeout       = 60

  idle_timeout                      = 60

  include_public_dns_record         = "yes"
  include_private_dns_record        = "yes"
  expose_to_public_internet         = "yes"
}


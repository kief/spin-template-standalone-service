
module "base-network" {
  source                    = "infrablocks/base-networking/aws"
  version                   = "~> 0.1"
  vpc_cidr                  = "10.1.0.0/16"
  region                    = "${var.region}"
  availability_zones        = "${var.availability_zones}"
  
  component                 = "${var.component}"
  deployment_identifier     = "${var.deployment_id}"
  
  include_lifecycle_events  = "no"
  private_zone_id           = "${module.dns-zones.private_zone_id}"
}

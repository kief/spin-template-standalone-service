
module "dns-zones" {
  source = "infrablocks/dns-zones/aws"
  version = "~> 0.1"

  domain_name             = "${var.deployment_id}.${var.service}.${var.component}.public.${var.base_dns_domain}"
  private_domain_name     = "${var.deployment_id}.${var.service}.${var.component}.private.${var.base_dns_domain}"

  private_zone_vpc_region = "${var.region}"
  private_zone_vpc_id     = "${data.aws_vpc.region_default.id}"
}

data "aws_vpc" "region_default" {
  default = "true"
}

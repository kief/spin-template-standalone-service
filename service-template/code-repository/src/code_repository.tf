
module "service-repository" {
  source    = "github.com/kief/terraform-aws-codecommit-repository.git"
  region    = "eu-west-1"
  estate_id = "${var.estate_id}"
  component = "${var.component}"
  service   = "${var.service}"
}

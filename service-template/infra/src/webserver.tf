
resource "aws_instance" "webserver" {

  ami                     = "${var.ami}"
  instance_type           = "t2.micro"
  subnet_id               = "${element(split (",", module.base-network.private_subnet_ids), 0)}"
  vpc_security_group_ids  = [ "${module.bastion.allow_ssh_from_bastion_security_group_id}" ]
  key_name                = "${aws_key_pair.webserver.key_name}"

  tags {
    Name                  = "webserver-${var.service}-${var.component}-${var.deployment_id}"
    ServerRole            = "webserver"
    DeploymentIdentifier  = "${var.deployment_id}"
    Service               = "${var.service}"
    Component             = "${var.component}"
    Estate                = "${var.estate_id}"
  }
}

resource "aws_key_pair" "webserver" {
  key_name = "webserver-${var.service}-${var.component}-${var.deployment_id}"
  public_key = "${file(var.webserver_ssh_key_file)}"
}

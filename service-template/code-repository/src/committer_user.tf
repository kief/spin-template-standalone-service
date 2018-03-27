
resource "aws_iam_user" "committer" {
  name = "committer-${var.service}-${var.component}-${var.estate_id}"
}

resource "aws_iam_group_membership" "committer_members" {
  name = "code_committers"
  users = [
    "${aws_iam_user.committer.name}"
  ]
  group = "${module.service-repository.committer_group_name}"
}

resource "aws_iam_user_ssh_key" "committer_key" {
  username   = "${aws_iam_user.committer.name}"
  encoding   = "SSH"
  public_key = "${file("${var.git_ssh_keyfile}")}"
}

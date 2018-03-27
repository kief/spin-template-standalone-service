
output "git_ssh_url" {
  description = "The URL for cloning the code repository"
  value = "${module.service-repository.clone_url_ssh}"
}

output "committer_ssh_id" {
  description = "The ID of the test ssh key"
  value = "${aws_iam_user_ssh_key.committer_key.ssh_public_key_id}"
}

output "checkout_policy_arn" {
  description = "ARN for the policy that allows checkouts"
  value = "${module.service-repository.checkout_policy_arn}"
}

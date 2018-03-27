
resource "aws_codebuild_project" "prodapply-project" {
  name         = "${var.service}-${var.component}-${var.estate_id}-ApplyToProdEnvironment"
  description  = "CodeBuild project to apply terraform to the ${var.service}-${var.component}-${var.estate_id} production instance"
  build_timeout      = "10"
  service_role = "${aws_iam_role.terraform_codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ruby:2.3.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "DEPLOYMENT_ID"
      "value" = "prod"
    }

  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec_apply.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}


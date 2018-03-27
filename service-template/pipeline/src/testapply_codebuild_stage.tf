
resource "aws_codebuild_project" "testapply-project" {
  name         = "${var.service}-${var.component}-${var.estate_id}-ApplyToTestEnvironment"
  description  = "CodeBuild project to test applying the ${var.service}-${var.component}-${var.estate_id} infrastructure"
  build_timeout      = "10"
  service_role = "${aws_iam_role.terraform_codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ruby:2.3.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "DEPLOYMENT_ID"
      "value" = "testapply"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec_testapply.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}


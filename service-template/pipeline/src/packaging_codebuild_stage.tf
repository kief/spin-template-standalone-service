
resource "aws_codebuild_project" "packaging-project" {
  name          = "${var.service}-${var.component}-${var.estate_id}-Packaging_Project"
  description   = "CodeBuild project to package the ${var.service}-${var.component}-${var.estate_id} codebase"
  build_timeout = "5"
  service_role  = "${aws_iam_role.packaging_codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/golang:1.7.3"
    type         = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}



resource "aws_codepipeline" "pipeline" {
  name     = "${var.service}-${var.component}-${var.estate_id}-pipeline"
  role_arn = "${aws_iam_role.pipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artefact_repository.bucket}"
    type     = "S3"
    # encryption_key {
    #   id   = "${data.aws_kms_alias.s3kmskey.arn}"
    #   type = "KMS"
    # }
  }

  stage {
    name = "CheckoutCode"

    action {
      name             = "Checkout"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"

      output_artifacts  = [ "infra-source" ],

      configuration {
        RepositoryName = "${var.service}-${var.component}-${var.estate_id}"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "PackageArtefact"

    action {
      name            = "Package"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "infra-source" ]
      output_artifacts  = [ "infra-package" ]

      configuration {
        ProjectName = "${aws_codebuild_project.packaging-project.name}"
      }
    }
  }

  stage {
    name = "ApplyToTestEnvironment"

    action {
      name            = "ApplyToTestEnvironment"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "infra-package" ]
      output_artifacts  = [ "testapply-results" ]

      configuration {
        ProjectName = "${aws_codebuild_project.testapply-project.name}"
      }
    }
  }

  stage {
    name = "ApproveForProduction"

    action {
      name            = "ApproveForProduction"
      category        = "Approval"
      provider        = "Manual"
      owner           = "AWS"
      version         = "1"
    }
  }

  stage {
    name = "ApplyToProdEnvironment"

    action {
      name            = "ApplyToProdEnvironment"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "infra-package" ]
      output_artifacts  = [ "prodapply-results" ]

      configuration {
        ProjectName = "${aws_codebuild_project.prodapply-project.name}"
      }
    }
  }
}


resource "aws_iam_role" "packaging_codebuild_role" {
  name = "${var.service}-${var.component}-${var.estate_id}_Packager"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "allow_codebuild_to_use_codecommit" {
  role       = "${aws_iam_role.packaging_codebuild_role.name}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.estate_id}/${var.component}/${var.service}/${var.service}-${var.component}-${var.estate_id}_CodeRepository_PipelineCheckout"
}


resource "aws_iam_policy" "packaging_codebuild_policy" {
  name        = "${var.service}-${var.component}-${var.estate_id}_Packaging_Codebuild_Policy"
  path        = "/service-role/"
  description = "Policies needed by the CodeBuild project for Packaging the ${var.service}-${var.component}-${var.estate_id} service"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:List*",
        "s3:PutObject"
      ]
    }
  ]
}
POLICY
}


resource "aws_iam_policy_attachment" "packaging_codebuild_attachment" {
  name       = "${var.service}-${var.component}-${var.estate_id}_Packaging_Codebuild_Attachment"
  policy_arn = "${aws_iam_policy.packaging_codebuild_policy.arn}"
  roles      = ["${aws_iam_role.packaging_codebuild_role.id}"]
}


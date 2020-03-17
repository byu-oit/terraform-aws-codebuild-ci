terraform {
  required_version = ">= 0.12.16"
  required_providers {
    aws = ">= 2.42"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "ci_cache" {
  bucket = "${var.name}-ci-cache"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
  tags = var.tags

  lifecycle_rule {
    enabled = true
    abort_incomplete_multipart_upload_days = 10
    id = "AutoAbortFailedMultipartUpload"
    tags = var.tags
  }
}


//TODO: CUSTOM-APPS-DEV account has the arn:aws:iam::022977965152:role/byu-apps-custom-codebuild
//TODO: Fix this policy
//TODO: Give access to all parameters? Pass in list?
resource "aws_iam_policy" "cbsetup-policy" {
  name        = "${var.name}-cbsetup-policy"
  path        = "/"
  description = ""
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.ci_cache.arn}",
        "${aws_s3_bucket.ci_cache.arn}/*"
      ],
      "Action": [
        "s3:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeParameters"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ],
      "Resource": [
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ci_codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.ci_codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.ci_codebuild_role.name
  policy_arn = aws_iam_policy.cbsetup-policy.arn
}


resource "aws_iam_role" "ci_codebuild_role" {
  name                 = "${var.name}-ci-role"
  //TODO: Discuss the need to maybe not have a permission boundary always?
  permissions_boundary = var.role_permissions_boundary_arn
  assume_role_policy   = <<EOT
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
EOT
  tags = var.tags
}

resource "aws_codebuild_project" "ci-codebuild-project" {
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = var.build_env_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }
  name         = var.name
  service_role = aws_iam_role.ci_codebuild_role.arn

  source {
    type      = "GITHUB"
    buildspec = var.buildspec
    location  = var.github_repo
    //TODO: Submodules?
    git_submodules_config {
      fetch_submodules = true
    }
    git_clone_depth     = 1
    report_build_status = true
    insecure_ssl        = false
  }

  //TODO: S3 Per account or CI?
  cache {
    type     = "S3"
    location = aws_s3_bucket.ci_cache.bucket
  }

  description   = "CI build project"
  badge_enabled = true

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  tags = var.tags
}



/*
Note: The secret attribute is only set on resource creation,
so if the secret is manually rotated, terraform will not pick up the
 change on subsequent runs. In that case, the webhook resource should
  be tainted and re-created to get the secret back in sync.
*/
//#TODO: Configurable events?
//Note That if we ever go to github enterprise this setup will have to change
resource "aws_codebuild_webhook" "webhook_configuration" {
  project_name = aws_codebuild_project.ci-codebuild-project.name
  filter_group {
    //TODO: Obviously need more events
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED"
    }
  }
}
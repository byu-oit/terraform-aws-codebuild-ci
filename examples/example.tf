provider "aws" {
  version = "~> 2.42"
  region  = "us-west-2"
}

module "acs" {
  source = "github.com/byu-oit/terraform-aws-acs-info?ref=v2.0.0"
}

module "github_ci" {
  source                        = "github.com/byu-oit/terraform-aws-codebuild-ci?ref=v0.0.6"
//  source = "../"
  name                          = "testci2"
  github_repo                   = "https://github.com/byu-oit/fake"
  role_permissions_boundary_arn = module.acs.role_permissions_boundary.arn
  source_version                = "dev"
}
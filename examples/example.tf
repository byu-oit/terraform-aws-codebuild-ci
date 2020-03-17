provider "aws" {
  version = "~> 2.42"
  region  = "us-west-2"
}

module "acs" {
  source = "github.com/byu-oit/terraform-aws-acs-info?ref=v2.0.0"
}

module "github_ci" {
  //  source = "github.com/byu-oit/terraform-aws-<module_name>?ref=v1.0.0"
  source                 = "../" # for local testing during module development
  name                   = "testci2"
  github_repo            = "https://github.com/byu-oit/parking-v2"
  role_permissions_boundary_arn    = module.acs.role_permissions_boundary.arn
  buildspec              = <<EOT
---
version: 0.2

phases:
  install:
    runtime-versions:
      java: openjdk11
      docker: 18
      nodejs: 10
  build:
    commands:
      - echo 'hi'
cache:
  paths:
    - '/root/cache/**/*'

  EOT
}

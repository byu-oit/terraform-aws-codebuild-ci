![Latest GitHub Release](https://img.shields.io/github/v/release/byu-oit/terraform-aws-codebuild-ci?sort=semver)

# Terraform AWS Codebuild CI for Github
Build Codebuild CI for Github

## Usage
```hcl
module "terraform-aws-codebuild-ci" {
  source                        = "github.com/byu-oit/terraform-aws-codebuild-ci?ref=v0.0.1"
  name                          = "ci-name"
  github_repo                   = "https://github.com/byu-oit/fakerepo"
  role_permissions_boundary_arn = module.acs.role_permissions_boundary.arn
  buildspec                     = "cb-buildspec.yml"
}
```

## Requirements
* Terraform version 0.12.16 or greater

## Inputs
| Name | Type  | Description | Default |
| --- | --- | --- | --- |
|name | string | Name of CI| |
|buildspec | string| The name of the buildspec file or the buildspec string | cb-buildspec.yml |
|role_permissions_boundary_arn |string | | |
|github_repo | string | Full Github repo name | |
|build_env_variables | map(string)| | {}|
|tags | map(string)| |{} |

## Outputs
| Name | Type | Description |
| ---  | ---  | --- |
| | | |

![Latest GitHub Release](https://img.shields.io/github/v/release/byu-oit/terraform-aws-codebuild-ci?sort=semver)

# terraform-aws-codebuild-ci
Build Codebuild CI for Github

## Usage
```hcl
module "terraform-aws-codebuild-ci" {
  source = "github.com/byu-oit/terraform-aws-codebuild-ci?ref=v1.0.0"
}
```

## Requirements
* Terraform version 0.12.16 or greater

## Inputs
| Name | Type  | Description | Default |
| --- | --- | --- | --- |
|name | | | |
|buildspec | | | |
|github_repo | | | |
|build_env_variables | | | |
|tags | | | |
|role_permissions_boundary_arn | | | |

## Outputs
| Name | Type | Description |
| ---  | ---  | --- |
| | | |

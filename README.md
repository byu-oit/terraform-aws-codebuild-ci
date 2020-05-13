![Latest GitHub Release](https://img.shields.io/github/v/release/byu-oit/terraform-aws-codebuild-ci?sort=semver)

# Terraform AWS Codebuild CI for Github

Creates a CodeBuild project for continuous integration on a specified GitHub repository. The CodeBuild project runs 
when a pull request is made to be merged into a target branch in a repository.

## Usage

```hcl
module "terraform-aws-codebuild-ci" {
  source                        = "github.com/byu-oit/terraform-aws-codebuild-ci?ref=v1.0.0"
  name                          = "ci-name"
  github_repo                   = "https://github.com/byu-oit/fakerepo"
  role_permissions_boundary_arn = module.acs.role_permissions_boundary.arn
  source_version                = "master"
}
```

## Requirements

* Terraform version 0.12.16 or greater
* AWS provider version 2.42 or greater

## Inputs

| Name | Type  | Description | Default |
| --- | --- | --- | --- |
|name | string | Name of CI| |
|role_permissions_boundary_arn |string | Role permission boundary ARN | |
|github_repo | string | Full Github repo name | |
|buildspec | string| The name of the buildspec file or the buildspec string | cb-buildspec.yml |
|build_env_variables | map(string)| | {}|
|tags | map(string)| |{} |
|source_version | string | Base branch to trigger CodeBuild's. | |
|webhook_filters | list(object) | [{type = "EVENT", pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED", exclude_matched_pattern = false}] |

### webhook_filters object

| Key | Values |
| --- | --- |
|type | EVENT, BASE_REF, HEAD_REF, ACTOR_ACCOUNT_ID, FILE_PATH |
|pattern | PUSH, PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED, PULL_REQUEST_MERGED |
|exclude_matched_pattern | true, false |

## Outputs

| Name | Type | Description |
| ---  | ---  | --- |
| codebuild_project | [object](https://www.terraform.io/docs/providers/aws/r/codebuild_project.html#argument-reference) | AWS CodeBuild project. |

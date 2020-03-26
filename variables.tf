variable "github_repo" {
  type = string
}

variable "buildspec" {
  type    = string
  default = "cb-buildspec.yml"
}

variable "name" {
  type = string
}

variable "build_env_variables" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "role_permissions_boundary_arn" {
  type    = string
  default = null
}

variable "source_version" {
  type = string
}

variable "webhook_filters" {
  type = list(object({
    type                    = string
    pattern                 = string
    exclude_matched_pattern = bool
  }))
  default = [
    {
      type                    = "EVENT"
      pattern                 = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED"
      exclude_matched_pattern = false
    }
  ]
}

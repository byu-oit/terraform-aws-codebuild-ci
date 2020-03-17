variable "github_repo" {
  type = string
}

variable "buildspec" {
  type    = string
  default = "cb-buildspec.yml" //TODO: Do we want a standard?
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
  type = string
  default = null
}

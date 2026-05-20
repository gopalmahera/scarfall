variable "tags" {
  type    = map(string)
  default = {}
}

variable "cluster_name" {
  type    = string
  default = null
}

variable "oidc_provider" {
  type    = string
  default = null
}

variable "name" {
  type    = string
  default = null
}

variable "namespace" {
  type    = string
  default = null
}

variable "release" {
  type    = string
  default = null
}
variable "helmversion" {
  type    = string
  default = null
}

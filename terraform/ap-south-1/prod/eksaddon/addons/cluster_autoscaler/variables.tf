variable "region" {
  type    = string
  default = ""
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
  default = "cluster-autoscaler"
}

variable "namespace" {
  type    = string
  default = "kube-addons"
}

variable "helmversion" {
  type    = string
  default = "9.29.3"
}

variable "system_node_group" {
  type    = string
  default = ""
}

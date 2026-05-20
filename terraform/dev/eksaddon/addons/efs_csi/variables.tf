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
  default = "ebs-csi-driver"
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
variable "efs_id" {
  type        = string
  default     = null
  description = "EFS ID"
}

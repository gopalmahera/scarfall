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
variable "ext4_iops" {
  type    = string
  default = "3000"
}
variable "ext4_throughput" {
  type    = string
  default = "125"
}
variable "ext4_encrypted" {
  type    = bool
  default = false
}
variable "ntfs_iops" {
  type    = string
  default = "3000"
}
variable "ntfs_throughput" {
  type    = string
  default = "125"
}
variable "ntfs_encrypted" {
  type    = bool
  default = false
}

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
  default = "external-dns"
}

variable "namespace" {
  type    = string
  default = "kube-addons"
}

variable "helmversion" {
  type    = string
  default = "8.7.0"
}

variable "public_dns_enable" {
  type    = bool
  default = false
}

variable "public_saname" {
  type    = string
  default = ""
}


variable "public_zone" {
  type    = string
  default = ""
}

variable "public_domain" {
  type    = string
  default = ""
}

variable "public_policy" {
  type    = string
  default = "upsert-only"
}

variable "public_role" {
  type    = string
  default = null
}

variable "private_dns_enable" {
  type    = bool
  default = false
}

variable "private_saname" {
  type    = string
  default = ""
}

variable "private_zone" {
  type    = string
  default = ""
}

variable "private_domain" {
  type    = string
  default = ""
}

variable "private_policy" {
  type    = string
  default = "upsert-only"
}

variable "private_role" {
  type    = string
  default = null
}

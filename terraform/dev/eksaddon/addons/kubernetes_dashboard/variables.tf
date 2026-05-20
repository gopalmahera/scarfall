variable "region" {
  type    = string
  default = ""
}

# variable "cluster_name" {
#   type    = string
#   default = ""
# }

variable "name" {
  type    = string
  default = "kubernetes-dashboard"
}

variable "namespace" {
  type    = string
  default = "kubernetes-dashboard"
}

variable "helmversion" {
  type    = string
  default = "7.9.0"
}

variable "alb_name" {
  type    = string
  default = "default"
}

variable "url" {
  type    = string
  default = "dashboard"
}

variable "external" {
  type    = bool
  default = false
}

variable "certificate_arn" {
  type    = string
  default = "dashboard"
}

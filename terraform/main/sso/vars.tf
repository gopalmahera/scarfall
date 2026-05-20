variable "aws_profile" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "groups" {
  description = "Map of IAM groups with their properties"
  type = map(object({
    enable       = bool
    display_name = string
    description  = string
  }))
}

variable "users" {
  description = "Map of users with their properties"
  type = map(object({
    enable       = bool
    display_name = string
    first_name   = string
    last_name    = string
    email        = string
    group        = list(string)
  }))
}

variable "customer_managed_policy" {
  description = "Map of customer-managed policies with their respective names, descriptions, and policy files."
  type = map(object({
    name        = string
    description = string
    file        = string
    account     = list(string)
  }))
}

variable "permission_set" {
  description = "Map of permission sets with their properties and attachments."
  type = map(object({
    name             = string
    description      = string
    session_duration = string
    attachment = list(object({
      type   = string
      policy = string
    }))
  }))
}

variable "group_account_assignment" {
  description = "Map of group account assignments with permission sets and accounts"
  type = map(list(object({
    permission_set = string
    account        = string
  })))
}

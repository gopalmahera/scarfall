# variable "aws_profile" {
#   type        = string
#   description = "AWS profile to use for authentication"
# }

variable "region" {
  type        = string
  description = "AWS region for resource deployment"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to apply to all resources"
}

variable "stages" {
  type        = map(any)
  default     = {}
  description = "Configuration for different deployment stages and their dependencies"
}

variable "environments" {
  type = map(object({
    profile = string
  }))
}

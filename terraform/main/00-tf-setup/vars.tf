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

variable "stages" {
  type    = map(any)
  default = {}
}

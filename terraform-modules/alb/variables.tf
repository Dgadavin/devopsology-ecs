variable "alb_name" {
}

variable "is_internal" {
  default = true
}

variable "environment" {
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "certificate_arn" {
}


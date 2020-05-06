variable "vpc_cidr_range_dev" {
  default = "172.29.20.0/22"
}

variable "vpc_cidr_range_stage" {
  default = "172.29.68.0/22"
}

variable "subnet_public_dev" {
  type = map(string)
  default = {
    us-east-1a = "172.29.20.0/24",
    us-east-1b = "172.29.21.0/24",
    us-east-1c = "172.29.22.0/24"
  }
}

variable "subnet_public_stage" {
  type = map(string)
  default = {
    us-east-1a = "172.29.68.0/24",
    us-east-1b = "172.29.69.0/24",
    us-east-1c = "172.29.70.0/24"
  }
}

variable "region" {
  default = "us-east-1"
}

variable "short_name" {
  default = "devops"
}


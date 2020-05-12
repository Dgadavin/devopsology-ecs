#Immutable variables
variable "service_name" {
  default = "devopsology-cluster"
}

variable "environment" {
}

#Common variables
variable "ClusterName" {
}

variable "CertificateARN" {
  default = ""
}

variable "AmiId" {
  default = "ami-040d7258a1baecb27"
}

variable "ssh_key_name" {
}

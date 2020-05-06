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
  default = "ami-0b84afb18c43907ba"
}

variable "ssh_key_name" {
}


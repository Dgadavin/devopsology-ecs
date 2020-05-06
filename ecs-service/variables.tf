#Immutable variables
variable "service_name" {
  default = "devops-nginx"
}

variable "Environment" {
}

variable "commit_hash" {
}

#Common variables
variable "main_cluster_stack_name" {
}

variable "ScaleMinCapacity" {
  default = "2"
}

variable "ScaleMaxCapacity" {
  default = "5"
}

variable "HostedZone" {
}

variable "HostedZoneID" {
}

variable "ELBDNSName" {
}


variable "aws_account" {
  type = object({
    access_key = string
    secret_key = string
    token      = string
  })
  description = "AWS Account Credentials"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "VPC-Peering"
}

variable "tfe_workspace" {
  type        = string
  description = "TFE workspace url"
  default     = "local"
}

variable "global_cidr" {
  type        = string
  description = "Global CIDR block"
  default     = "10.112.0.0/12"
}

variable "global_services_vpc_cidr" {
  type        = string
  description = "Global services VPC CIDR block"
  default     = "10.112.0.0/23"
}

variable "global_services_private_subnet_a_cidr" {
  type        = string
  description = "Global services subnet (private-a) CIDR block"
  default     = "10.112.0.0/25"
}

variable "global_services_private_subnet_b_cidr" {
  type        = string
  description = "Global services subnet (private-b) CIDR block"
  default     = "10.112.0.128/25"
}

variable "client_vpc_cidr" {
  type        = string
  description = "Client VPC CIDR block"
  default     = "10.116.0.0/19"
}

variable "client_private_subnet_a_cidr" {
  type        = string
  description = "Client subnet (private-a) CIDR block"
  default     = "10.116.0.0/20"
}

variable "client_private_subnet_b_cidr" {
  type        = string
  description = "Client subnet (private-b) CIDR block"
  default     = "10.116.16.0/20"
}

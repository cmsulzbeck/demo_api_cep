variable "name" {
  description = "Name prefix for network resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for public subnets."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "EC2 instance name."
  type        = string
}

variable "ami_id" {
  description = "Optional AMI override. Defaults to latest Amazon Linux 2023."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the instance."
  type        = string
}

variable "security_group_ids" {
  description = "Security groups attached to the instance."
  type        = list(string)
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address."
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB."
  type        = number
  default     = 20
}

variable "user_data" {
  description = "EC2 user-data script."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

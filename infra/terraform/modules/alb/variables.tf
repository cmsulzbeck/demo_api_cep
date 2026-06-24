variable "name" {
  description = "ALB name."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets where the ALB will run."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group attached to the ALB."
  type        = string
}

variable "active_target_group" {
  description = "Key of the target group receiving listener traffic."
  type        = string
}

variable "target_groups" {
  description = "Target groups and EC2 instances attached to them."
  type = map(object({
    name                 = string
    port                 = number
    instance_ids         = list(string)
    health_check_path    = string
    health_check_matcher = string
  }))
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used in resource names."
  type        = string
  default     = "api-cep"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "qa"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for public subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed to access the QA ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH to QA EC2 instances. Leave empty to rely on SSM."
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "EC2 instance type for QA."
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Optional EC2 key pair name."
  type        = string
  default     = null
}

variable "api_image" {
  description = "Docker image for the Spring Boot API."
  type        = string
}

variable "wiremock_image" {
  description = "WireMock Docker image."
  type        = string
  default     = "wiremock/wiremock:3.13.2"
}

variable "hsqldb_image" {
  description = "Image used to run HSQLDB server."
  type        = string
  default     = "maven:3.9.9-eclipse-temurin-17"
}

variable "database_username" {
  description = "Database username used by the API."
  type        = string
  default     = "SA"
}

variable "database_password" {
  description = "Database password used by the API."
  type        = string
  default     = ""
  sensitive   = true
}

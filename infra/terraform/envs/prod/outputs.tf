output "alb_dns_name" {
  description = "PROD ALB DNS name."
  value       = module.alb.dns_name
}

output "active_color" {
  description = "Currently active PROD color."
  value       = var.active_color
}

output "blue_public_ip" {
  description = "Blue EC2 public IP."
  value       = module.blue_app.public_ip
}

output "green_public_ip" {
  description = "Green EC2 public IP."
  value       = module.green_app.public_ip
}

output "database_private_ip" {
  description = "Shared database EC2 private IP."
  value       = module.database.private_ip
}

output "alb_dns_name" {
  description = "QA ALB DNS name."
  value       = module.alb.dns_name
}

output "app_public_ip" {
  description = "QA EC2 public IP."
  value       = module.app.public_ip
}

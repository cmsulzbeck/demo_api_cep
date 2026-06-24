output "alb_security_group_id" {
  description = "ALB security group ID."
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "App host security group ID."
  value       = aws_security_group.app.id
}

output "database_security_group_id" {
  description = "Database host security group ID."
  value       = aws_security_group.database.id
}

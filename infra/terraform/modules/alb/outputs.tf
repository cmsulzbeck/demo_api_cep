output "dns_name" {
  description = "ALB DNS name."
  value       = aws_lb.this.dns_name
}

output "target_group_arns" {
  description = "Target group ARNs keyed by target group name."
  value = {
    for key, target_group in aws_lb_target_group.this : key => target_group.arn
  }
}

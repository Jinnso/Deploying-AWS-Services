output "alb_dns_name" {
  description = "DNS público del Load Balancer (URL para acceder a la app)"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ARN del Target Group (necesario para el servicio ECS)"
  value       = aws_lb_target_group.app.arn
}
output "execution_role_arn" {
  description = "ARN del rol de ejecucion para ECS"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "task_role_arn" {
  description = "ARN del rol de la tarea para ECS"
  value       = aws_iam_role.ecs_task_role.arn
}
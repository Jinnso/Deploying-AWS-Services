output "secret_arn" {
  description = "ARN del secreto creado (necesario para las políticas de IAM)"
  value       = aws_secretsmanager_secret.db_password.arn
}
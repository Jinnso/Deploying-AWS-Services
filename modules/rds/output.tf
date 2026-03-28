output "db_endpoint" {
  description = "Endpoint de conexión de la base de datos"
  value       = aws_db_instance.main.endpoint
}
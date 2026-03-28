variable "environment" {
  description = "Ambiente de despliegue (ej. test, prod)"
  type        = string
}

variable "db_password" {
  description = "Contraseña para la base de datos RDS"
  type        = string
  sensitive   = true # Esto evita que Terraform la imprima en la consola
}
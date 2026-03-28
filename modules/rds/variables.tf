variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs de las subredes privadas donde vivirá la BD"
  type        = list(string)
}

variable "db_instance_class" {
  description = "Tipo de instancia para la base de datos (ej. db.t3.micro)"
  type        = string
}

variable "rds_security_group_id" {
  description = "ID del Security Group para RDS"
  type        = string
}

variable "db_password" {
  description = "Contraseña de la base de datos"
  type        = string
  sensitive   = true
}
variable "cluster_name" {
  description = "El nombre del cluster ECS"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se desplegará ECS"
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de IDs de las subredes privadas para las tareas"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ID del Security Group para las tareas de ECS"
  type        = string
}

variable "target_group_arn" {
  description = "ARN del Target Group del ALB"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN del rol de ejecución de ECS"
  type        = string
}

variable "task_role_arn" {
  description = "ARN del rol de la tarea de ECS"
  type        = string
}

variable "app_environment" {
  description = "Entorno de la aplicación (test o prod) para inyectar en el contenedor"
  type        = string
}
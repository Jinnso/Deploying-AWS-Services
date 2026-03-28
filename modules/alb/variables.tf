variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs de las subredes públicas para el ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID del Security Group para el ALB"
  type        = string
}
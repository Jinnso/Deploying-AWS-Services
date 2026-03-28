variable "environment" {
  description = "El ambiente (test o prod)"
  type        = string
}

variable "cluster_name" {
  description = "Nombre del clúster para nombrar los roles"
  type        = string
}
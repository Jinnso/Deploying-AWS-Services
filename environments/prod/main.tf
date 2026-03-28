terraform {
  backend "s3" {
    bucket         = "nicojarpa-private-terraform-bucket" # [cite: 54]
    key            = "env/test/terraform.tfstate"         # OJO: Ruta específica para TEST
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"              # [cite: 54]
    encrypt        = true
  }
}

# Configuración del Provider (obligatorio)
provider "aws" {
  region = "us-east-1" # Asegúrate de usar la región que prefieras
}

# 1. Red (VPC)
module "vpc" {
  source               = "../../modules/vpc"
  container_name       = "prod-app"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

# 2. Seguridad (SGs e IAM)
module "security_groups" {
  source      = "../../modules/security_groups"
  environment = "prod"
  vpc_id      = module.vpc.vpc_id
}

module "iam" {
  source       = "../../modules/iam"
  environment  = "prod"
  cluster_name = "app-cluster"
}

# 3. Balanceador de Carga (ALB)
module "alb" {
  source                = "../../modules/alb"
  environment           = "prod"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_cidrs # Recuerda renombrar tus outputs en el modulo vpc
  alb_security_group_id = module.security_groups.alb_sg_id
}

# 4. Repositorio de Imágenes (ECR)
module "ecr" {
  source          = "../../modules/ecr"
  repository_name = "prod-app-repo"
}

# 5. Clúster y Servicio (ECS)
module "ecs" {
  source                = "../../modules/ecs"
  cluster_name          = "prod-app-cluster"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_cidrs
  ecs_security_group_id = module.security_groups.ecs_sg_id
  target_group_arn      = module.alb.target_group_arn
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  app_environment       = "prod" # Esta es la variable que inyectaremos en el contenedor
  db_host                = module.rds.db_endpoint
  db_password_secret_arn = module.secrets.secret_arn
  ecr_image_url          = "${module.ecr.repository_url}:latest"
}

# 6. Base de Datos y Secretos (RDS)
module "secrets" {
  source      = "../../modules/secrets"
  environment = "prod"
  db_password = var.db_password # Esta variable se pasará desde afuera por seguridad
}

module "rds" {
  source                = "../../modules/rds"
  environment           = "prod"
  private_subnet_ids    = module.vpc.private_subnet_cidrs
  db_instance_class     = "db.t3.micro" # Tamaño pequeño para proding
  rds_security_group_id = module.security_groups.rds_sg_id
  db_password           = var.db_password
}
# 1. El Cluster ECS
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


# 2. Task Definition (La "receta" de tu contenedor)
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.cluster_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  # Faltan los roles de IAM (execution_role y task_role) que son obligatorios

  container_definitions = jsonencode([{
    name      = "app-container"
    image     = "nginx:latest" # Imagen de ejemplo
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

# 4. El Servicio ECS (El que mantiene las tareas corriendo)
resource "aws_ecs_service" "main" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false # Fargate en subredes privadas no necesita IP pública (sale por el NAT Gateway)
  }
}
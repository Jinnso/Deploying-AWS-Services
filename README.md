# AWS Cloud Infrastructure & CI/CD Pipeline

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)

## 📌 Overview
This repository contains the complete Infrastructure as Code (IaC) and CI/CD configuration required to deploy a modern, scalable, and secure web application on Amazon Web Services (AWS). It demonstrates core Site Reliability Engineering (SRE) and DevOps principles, including immutable infrastructure, zero-downtime deployments, and least-privilege security.

## 🏗️ Architecture



The infrastructure is provisioned using **Terraform** and follows a modular design. Key components include:
* **Networking:** A custom VPC with public subnets (for the Load Balancer) and private subnets (for the application and database), managed via NAT Gateways.
* **Compute:** Amazon ECS running on AWS Fargate (Serverless compute for containers).
* **Routing:** Application Load Balancer (ALB) distributing traffic to healthy ECS tasks across multiple Availability Zones.
* **Database:** Amazon RDS (PostgreSQL) deployed in a private subnet.
* **Storage & Secrets:** Amazon ECR for Docker images and AWS Secrets Manager for secure database credential injection.
* **Observability:** Centralized logging using Amazon CloudWatch.

## 🔒 Security & SRE Best Practices Implemented
* **Security Group Chaining:** The RDS database only accepts traffic explicitly coming from the ECS tasks' Security Group.
* **Least Privilege IAM:** Custom IAM roles are strictly scoped for ECS task execution, reading specific secrets, and writing to CloudWatch.
* **Secret Management:** Database passwords are dynamically generated, stored in AWS Secrets Manager, and injected into the containers at runtime (never hardcoded).
* **Multi-Stage Docker Builds:** Optimized, lightweight Alpine-based container images running as a non-root `node` user to prevent privilege escalation.
* **GitOps CI/CD:** Infrastructure and application deployments are fully automated and triggered exclusively via Pull Requests to `develop` and `main` branches.

## 🚀 CI/CD Pipeline (GitHub Actions)
The workflow (`deploy.yml`) handles both the application build and infrastructure provisioning:
1.  **Determine Environment:** Dynamically targets the `test` or `prod` environment based on the Git branch.
2.  **Pre-provisioning:** Uses Terraform targeting to create the ECR repository first.
3.  **Build & Push:** Builds the Docker image and pushes it to AWS ECR.
4.  **Plan & Apply:** Runs `terraform plan` and `terraform apply` to provision the rest of the network, compute, and data layers.

## 📂 Project Structure
```text
.
├── .github/workflows/      # GitHub Actions CI/CD pipeline
├── app/                    # Node.js application source code and Dockerfile
├── environments/           # Environment-specific state and variables
│   ├── test/               # Staging environment configuration
│   └── prod/               # Production environment configuration
└── modules/                # Reusable Terraform modules
    ├── alb/                # Application Load Balancer & Target Groups
    ├── ecr/                # Elastic Container Registry
    ├── ecs/                # ECS Cluster, Task Definition, and Services
    ├── iam/                # IAM Roles and Policies
    ├── network/            # VPC, Subnets, IGW, and NAT Gateways
    ├── rds/                # Relational Database Service (PostgreSQL)
    ├── secrets/            # AWS Secrets Manager
    └── security_groups/    # Security Groups (ALB, ECS, RDS)

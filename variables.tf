variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "proyecto6"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.11.0/24"
}

variable "container_name" {
    description = "Name of the container"
    type        = string
    default     = "app-container"
}

variable "container_image" {
    description = "Docker image for ECS task"
    type        = string
    default     = "nginx:latest"
}

variable "container_port" {
    description = "Port exposed by container"
    type        = number
    default     = 80
}

variable "task_cpu" {
    description = "Task CPU units"
    type        = number
    default     = 256
}
variable "task_memory" {
    description = "Task memory in MiB"
    type        = number
    default     = 512
}

variable "desired_count" {
    description = "Number of desired tasks"
    type        = number
    default     = 2
}

variable "alb_port" {
    description = "ALB listener port"
    type        = number
    default     = 80
}
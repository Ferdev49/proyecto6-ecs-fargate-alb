output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.main.arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group name"
  value       = aws_cloudwatch_log_group.ecs.name
}

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "ECS Security Group ID"
  value       = aws_security_group.ecs.id
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public_2.id
}

output "private_subnet_1_id" {
  description = "Private Subnet 1 ID"
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "Private Subnet 2 ID"
  value       = aws_subnet.private_2.id
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${aws_lb.main.dns_name}"
}

output "ecs_summary" {
  description = "ECS Deployment Summary"
  value = {
    cluster_name       = aws_ecs_cluster.main.name
    service_name       = aws_ecs_service.main.name
    desired_count      = var.desired_count
    alb_dns            = aws_lb.main.dns_name
    application_url    = "http://${aws_lb.main.dns_name}"
    log_group          = aws_cloudwatch_log_group.ecs.name
    task_cpu           = var.task_cpu
    task_memory        = var.task_memory
  }
}
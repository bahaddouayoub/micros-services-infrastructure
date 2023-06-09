variable "family_name" {
  type        = string
  description = "The name of the application and the family"
}

variable "container_name" {
  type        = string
  description = "The name of the application and the container"
}

variable "app_image" {
  type = string 
  description = "Container image to be used for application in task definition file"
}

variable "environment" {
  type = string
  description = "The application environment"
}

variable "fargate_cpu" {
  type = number
  description = "Fargate cpu allocation"
}

variable "fargate_memory" {
  type = number
  description = "Fargate memory allocation"
}

variable "app_port" {
  type = number
  description = "Application port"
}

# 

variable "vpc_id" {
  type = string 
  description = "The id for the VPC where the ECS container instance should be deployed"
}

variable "cluster_id" {
  type = string 
  description = "Cluster ID"
}

variable "app_count" {
  type = string 
  description = "The number of instances of the task definition to place and keep running."
}

variable "dns_name" {
  type = string 
  description = "domain name that will for service to service communication"
}

variable "port_mapping" {
  type = string 
  description = "the name of the port in task definition"
}

variable "namespace" {
  type = string 
  description = "the namespace used in service connect"
}

# Application load balancer variables
variable "private_subnet_ids" {
  type = list(string) 
  description = "the private_subnet_ids "
}


variable "security_group_ecs_tasks_name" {
  type        = string
  default     = "ecs-tasks-sg"
  description = "ECS Tasks security group name"
}


variable "security_group_ecs_tasks_description" {
  type        = string
  default     = "allow inbound access from the ECS ALB only"
  description = "ECS tasks security group description"
}

variable "alb_sg" {
  type        = string
  description = "alb trafic from alb-sg to ecs tasks"
}

variable "health_check_path" {
  type = string 
  description = "the health_check_path "
}

variable "path_pattern" {
  type = string 
  description = "the path_pattern "
}

variable "aws_lb" {
  # type = string 
  description = "Application load balancer"
}


variable "aws_lb_listener_arn" {
  type = string 
  description = "aws_lb listener_arn"
}

variable "tg_name" {
  type = string
  description = "target group"
}

variable "priority" {
  type = number
  description = "target group"
}


variable "service_connect_port" {
  type = number
  description = "service connect port"
}
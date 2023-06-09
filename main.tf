# terraform {
#     backend "s3" {
#         bucket = "state-bucket"
#         key = "state.tfstate"
#         region = var.region
#     }
# }

provider "aws" {
  region = var.region
}


# network
module "vpc_for_ecs_fargate" {
  source                        = "./vpc-cluster"
  environment                   = var.environment
  vpc_tag_name                  = var.vpc_tag_name
  vpc_cidr_block                = var.vpc_cidr_block
  number_of_private_subnets     = 3
  private_subnet_tag_name       = var.private_subnet_tag_name
  security_group_lb_name        = var.security_group_lb_name
  private_subnet_cidr_blocks    = var.private_subnet_cidr_blocks
  security_group_lb_description = var.security_group_lb_description
  # app_port = var.app_port
  availability_zones = var.availability_zones
  region             = var.region
}


#ECS cluster
module ecs_cluster {
  source = "./ecs-cluster"
  name = "ecs-cluster-${var.environment}"
  cluster_tag_name = "cluster-${var.environment}"
  namespace = var.namespace
}

#MSKcluster
module msk_cluster {
  source = "./msk-cluster"
  cluster_name =  "msk-cluster-${var.environment}" 
  private_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
  vpc_id = module.vpc_for_ecs_fargate.vpc_id
}


# #ECS load balancers
# module load_balancers {
#   source = "./load-balancers"
#   aws_security_group_alb_id = module.vpc_for_ecs_fargate.aws_security_group_alb_id
#   vpc_id = module.vpc_for_ecs_fargate.vpc_id
#   private_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
#   # aws_lb_target_group_arn = module.
#   environment = var.environment
# }


# # ECS task definition and service for movie
# module fargate_cluster_movie {
#   # Task definition and NLB
#   source = "./fargate-cluster"
#   family_name = "movie"
#   dns_name = var.movie_dns_name
#   container_name = var.movie_container_name
#   app_image = var.app_image_movie
#   namespace = var.namespace
#   port_mapping = var.movie_port_mapping
#   fargate_cpu                 = 1024
#   fargate_memory              = 2048
#   app_port = var.app_port_movie
#   vpc_id = module.vpc_for_ecs_fargate.vpc_id
#   environment = var.environment

#   # load balancers
#   health_check_path = var.health_check_path_movie
#   tg_name = var.tg_name_movie
#   path_pattern = var.path_pattern_movie
#   aws_lb = module.load_balancers.aws_lb
#   aws_lb_listener_arn = module.load_balancers.aws_lb_listener_arn
#   priority = 2


#   # Service
#   service_connect_port = 80
#   cluster_id = module.ecs_cluster.id 
#   app_count = var.app_count
#   alb_sg = module.vpc_for_ecs_fargate.aws_security_group_alb_id
#   security_group_ecs_tasks_name = var.security_group_ecs_tasks_name_movie
#   private_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids

# }




# # # # ECS task definition and service for home
# module fargate_cluster_home {
#   # Task definition and NLB
#   source = "./fargate-cluster"
#   family_name = "home"
#   dns_name = var.home_dns_name
#   container_name = var.home_container_name
#   app_image = var.app_image_home
#   namespace = var.namespace
#   port_mapping = var.home_port_mapping
#   fargate_cpu                 = 1024
#   fargate_memory              = 2048
#   app_port = var.app_port_home
#   vpc_id = module.vpc_for_ecs_fargate.vpc_id
#   environment = var.environment

#   # load balancers
#   health_check_path = var.health_check_path_home
#   tg_name = var.tg_name_home
#   path_pattern = var.path_pattern_home
#   aws_lb = module.load_balancers.aws_lb
#   aws_lb_listener_arn = module.load_balancers.aws_lb_listener_arn
#   priority = 3


#   # Service
#   service_connect_port = 81
#   cluster_id = module.ecs_cluster.id 
#   app_count = var.app_count
#   alb_sg = module.vpc_for_ecs_fargate.aws_security_group_alb_id
#   security_group_ecs_tasks_name = var.security_group_ecs_tasks_name_home
#   private_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
# }


# # API Gateway and VPC link
# module api_gateway {
#   source = "./api-gateway"
#   name = "${var.environment}"
#   integration_input_type = "HTTP_PROXY"
#   path_part = "{proxy+}"
#   app_port = 80
#   nlb_dns_name = module.load_balancers.nlb_dns_name
#   nlb_arn = module.load_balancers.nlb_arn
#   environment = var.environment
# }


# # RDS postgresql
# module rds_postgresql {
#   source = "./rds-postgres"
#   subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
#   vpc_id = module.vpc_for_ecs_fargate.vpc_id
#   parameter_group_name = var.parameter_group_name
#   parameter_group_family = var.parameter_group_family
#   param_log_statement = var.param_log_statement
#   allocated_storage     = var.allocated_storage
#   max_allocated_storage = var.max_allocated_storage
#   storage_type          = var.storage_type
#   instance_class         = var.instance_class
#   db_username               = var.db_username
#   db_password               = var.db_password
#   db_port                  = var.db_port
#   multi_az               = var.multi_az
#   skip_final_snapshot    = var.skip_final_snapshot
#   backup_retention_period= var.backup_retention_period 
#   enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
# }


module "vpc" {
  source = "../modules/aws/vpc"
  env    = local.env
}

module "subnet" {
  source = "../modules/aws/subnet"
  env    = local.env
  vpc_id = module.vpc.id_cloud_pratica
}

module "internet_gateway" {
  source = "../modules/aws/internet_gateway"
  env    = local.env
  vpc_id = module.vpc.id_cloud_pratica
}

module "route_table" {
  source                   = "../modules/aws/route_table"
  env                      = local.env
  vpc_id                   = module.vpc.id_cloud_pratica
  internet_gateway_id      = module.internet_gateway.id_cloud_pratica
  public_subnet_ids        = local.public_subnet_ids
  private_subnet_ids       = local.private_subnet_ids
  nat_network_interface_id = "eni-06dec4a8b0831c38d" # TODO natインスタンスimport時、ハードコーディング修正
}

module "security_group" {
  source = "../modules/aws/security_group"
  env    = local.env
  vpc_id = module.vpc.id_cloud_pratica
}

module "ecr" {
  source = "../modules/aws/ecr"
  env    = local.env
}

module "secrets_manager" {
  source = "../modules/aws/secrets_manager"
  env    = local.env
}

module "sqs" {
  source     = "../modules/aws/sqs"
  env        = local.env
  account_id = local.account_id
}

module "ses" {
  source = "../modules/aws/ses"
  env    = local.env
}

module "iam_role" {
  source = "../modules/aws/iam_role"
  env    = local.env
}

module "ec2" {
  source    = "../modules/aws/ec2"
  env       = local.env
  subnet_id = module.subnet.id_public_subnet_1a
  bastion = {
    iam_instance_profile = "cp-bastion-${local.env}"
    security_group_id    = module.security_group.id_bastion
  }
  nat_1a = {
    iam_instance_profile = "cp-nat-${local.env}"
    security_group_id    = module.security_group.id_nat
  }
}

module "rds_unit" {
  source                              = "../modules/aws/rds_unit"
  env                                 = local.env
  identifier                          = "cloud-pratica-${local.env}"
  db_name                             = "slack_metrics"
  family                              = "postgres16"
  engine_version                      = "16.8"
  instance_class                      = "db.t3.micro"
  subnet_group_name                   = "cp-db-subnet-group-${local.env}"
  parameter_group_name                = "cp-db-parameter-group-${local.env}"
  private_subnet_ids                  = local.private_subnet_ids
  iam_database_authentication_enabled = false
  security_group_ids = [
    module.security_group.id_rds,
  ]
}

module "acm_cloud_pratica_com_ap_northeast_1" {
  source      = "../modules/aws/acm_unit"
  domain_name = "*.${local.base_host}"
  providers = {
    aws = aws
  }
}

module "acm_cloud_pratica_com_us_east_1" {
  source      = "../modules/aws/acm_unit"
  domain_name = "*.${local.base_host}"
  providers = {
    aws = aws.us_east_1
  }
}

module "ecs" {
  source = "../modules/aws/ecs"
  env    = local.env
}

module "ecs_task_definition" {
  source = "../modules/aws/ecs_task_definition"
}

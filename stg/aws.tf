module "vpc" {
  source = "../modules/aws/vpc"
  env    = "stg"
}

module "subnet" {
  source = "../modules/aws/subnet"
  env    = "stg"
  vpc_id = module.vpc.id_cloud_pratica
}

import {
  to = module.subnet.aws_subnet.public_subnet_1c
  id = "subnet-0bb6c159b9dfee3fa"
}

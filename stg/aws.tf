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
  to = module.subnet.aws_subnet.public_subnet_1a
  id = "subnet-04d458ba99bdfc014"
}

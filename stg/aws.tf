module "vpc" {
  source = "../modules/aws/vpc"
  env    = "stg"
}
import {
  to = aws_subnet.private_subnet_1a
  id = ""
}

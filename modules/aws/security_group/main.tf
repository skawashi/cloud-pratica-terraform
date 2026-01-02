resource "aws_security_group" "alb_cp" {
  region      = "ap-northeast-1"
  vpc_id      = var.vpc_id
  name        = "cp-alb-${var.env}"
  description = "Managed by Terraform"
  tags = {
    Name = "cp-alb-${var.env}"
  }
}

resource "aws_security_group" "bastion" {
  region      = "ap-northeast-1"
  vpc_id      = var.vpc_id
  name        = "cp-bastion-${var.env}"
  description = "Managed by Terraform"
  tags = {
    Name = "cp-bastion-${var.env}"
  }
}


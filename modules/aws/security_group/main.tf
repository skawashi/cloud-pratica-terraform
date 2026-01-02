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

resource "aws_security_group" "nat" {
  region      = "ap-northeast-1"
  vpc_id      = var.vpc_id
  name        = "cp-nat-${var.env}"
  description = "Managed by Terraform"

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]

  ingress = [{
    cidr_blocks      = ["10.0.128.0/18", "10.0.192.0/18"]
    description      = "Allow traffic from private subnets"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  tags = {
    Name = "cp-nat-${var.env}"
  }
}

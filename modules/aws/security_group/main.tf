resource "aws_security_group" "alb_cp" {
  region      = "ap-northeast-1"
  vpc_id      = var.vpc_id
  name        = "cp-alb-${var.env}"
  description = "Managed by Terraform"

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 443
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 443
  }]

  tags = {
    Name = "cp-alb-${var.env}"
  }
}


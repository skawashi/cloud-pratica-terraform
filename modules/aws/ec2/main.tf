resource "aws_instance" "nat_1a" {
  ami                    = "ami-03852a41f1e05c8e4"
  availability_zone      = "ap-northeast-1a"
  iam_instance_profile   = var.nat_1a.iam_instance_profile
  instance_type          = "t2.micro"
  source_dest_check      = false
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.nat_1a.security_group_id]
  tags = {
    Name = "cp-nat-1a-${var.env}"
  }
}

resource "aws_instance" "bastion" {
  ami                    = "ami-03852a41f1e05c8e4"
  availability_zone      = "ap-northeast-1a"
  iam_instance_profile   = var.bastion.iam_instance_profile
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.bastion.security_group_id]
  tags = {
    Name = "cp-bastion-${var.env}"
  }
}

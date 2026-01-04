resource "aws_instance" "nat" {
  ami                    = "ami-03852a41f1e05c8e4"
  availability_zone      = "ap-northeast-1a"
  iam_instance_profile   = "cp-nat-${var.env}"
  instance_type          = "t2.micro"
  source_dest_check      = false
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.nat_1a.security_group_id]
  tags = {
    Name = "cp-nat-1a-${var.env}"
  }
}

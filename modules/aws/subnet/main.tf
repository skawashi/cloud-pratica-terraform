resource "aws_subnet" "private_subnet_1a" {
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.128.0/18"
  tags = {
    Name = "private-subnet-1a-${var.env}"
  }
  vpc_id = var.vpc_id
}

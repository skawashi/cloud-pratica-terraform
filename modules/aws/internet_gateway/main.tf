resource "aws_internet_gateway" "cloud_pratica" {
  region = "ap-northeast-1"
  tags = {
    Name = "cp-igw-${var.env}"
  }
  vpc_id = var.vpc_id
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "cp-db-subnet-group-${var.env}"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "cp-db-subnet-group-${var.env}"
  }
}

resource "aws_db_parameter_group" "parameter_group" {
  family = "postgres16"
  name   = "cp-db-parameter-group-${var.env}"
}

resource "aws_db_instance" "main" {
  engine                              = "postgres"
  identifier                          = "cloud-pratica-${var.env}"
  db_name                             = "slack_metrics"
  engine_version                      = "16.8"
  instance_class                      = "db.t3.micro"
  username                            = "postgres"
  password                            = null # sensitive
  ca_cert_identifier                  = "rds-ca-rsa2048-g1"
  max_allocated_storage               = 1000
  allocated_storage                   = 20
  apply_immediately                   = null
  copy_tags_to_snapshot               = true
  performance_insights_enabled        = true
  skip_final_snapshot                 = true
  storage_encrypted                   = true
  iam_database_authentication_enabled = false
  vpc_security_group_ids              = ["sg-0467622a37cd361bf"]
  db_subnet_group_name                = aws_db_subnet_group.subnet_group.name
  parameter_group_name                = "cp-db-parameter-group-stg"
  availability_zone                   = "ap-northeast-1a"
  storage_type                        = "gp2"
  lifecycle {
    ignore_changes = [password]
  }
}

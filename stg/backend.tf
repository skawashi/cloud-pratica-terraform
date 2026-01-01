terraform {
  backend "s3" {
    bucket = "cp-terraform-kawashima-stg"
    key    = "main.tfstate"
    region = "ap-northeast-1"
  }
}


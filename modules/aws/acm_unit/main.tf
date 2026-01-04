variable "domain_name" {
  type = string
}

resource "aws_acm_certificate" "acm_cloud_pratica_com_ap_northeast_1" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

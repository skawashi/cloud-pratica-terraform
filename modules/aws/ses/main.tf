resource "aws_sesv2_email_identity" "cloud_pratica" {
  email_identity = "${var.env}.cloud-pratica.kawashima.world" // TODO domain設定
}

resource "aws_sesv2_email_identity_mail_from_attributes" "cloud_pratica" {
  email_identity   = "${var.env}.cloud-pratica.kawashima.world"      // TODO domain設定
  mail_from_domain = "mail.${var.env}.cloud-pratica.kawashima.world" // TODO domain設定
}

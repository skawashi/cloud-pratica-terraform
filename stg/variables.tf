locals {
  env        = "stg"
  account_id = "480957638549"
  region     = "ap-northeast-1"
  base_host  = "stg.cloud-pratica.kawashima.world"

  public_subnet_ids = [
    module.subnet.id_public_subnet_1a,
    module.subnet.id_public_subnet_1c,
  ]

  private_subnet_ids = [
    module.subnet.id_private_subnet_1a,
    module.subnet.id_private_subnet_1c,
  ]
}

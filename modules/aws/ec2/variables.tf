variable "env" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "bastion" {
  type = object({
    iam_instance_profile = string
    security_group_id    = string
  })
}

variable "nat_1a" {
  type = object({
    iam_instance_profile = string
    security_group_id    = string
  })
}

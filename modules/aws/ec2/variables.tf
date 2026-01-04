variable "env" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "bastion" {
  type = object({
    # デフォルト値は、Amazon Linux 2023 の AMI ID
    # ami_id               = optional(string, "ami-023ff3d4ab11b2525")
    # iam_instance_profile = string
    security_group_id = string
  })
}

variable "nat_1a" {
  type = object({
    # デフォルト値は、Amazon Linux 2023 の AMI ID
    # ami_id               = optional(string, "ami-023ff3d4ab11b2525")
    # iam_instance_profile = string
    security_group_id = string
  })
}

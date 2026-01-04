variable "env" {
  type = string
}

variable "identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "family" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "subnet_group_name" {
  type = string
}

variable "parameter_group_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "iam_database_authentication_enabled" {
  type = bool
}

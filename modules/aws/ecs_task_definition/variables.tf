/******************************************************
 Common Variables
 ******************************************************/
variable "env" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "secrets_manager_arn_db_main_instance" {
  type = string
}

variable "arn_cp_config_bucket" {
  type = string
}

variable "ecs_task_specs" {
  type = object({
    slack_metrics_api = object({
      cpu    = number
      memory = number
    })
    slack_metrics_batch = object({
      cpu    = number
      memory = number
    })
    db_migrator = object({
      cpu    = number
      memory = number
    })
  })
}

/*************************
 * ECR (imageタグを含むURL)
 *************************/
variable "ecr_url_slack_metrics" {
  type = string
}

variable "ecr_url_db_migrator" {
  type = string
}

/******************************************************
 ECS Task Role
 ******************************************************/
variable "ecs_task_role_arn_slack_metrics" {
  type = string
}

variable "ecs_task_role_arn_db_migrator" {
  type = string
}

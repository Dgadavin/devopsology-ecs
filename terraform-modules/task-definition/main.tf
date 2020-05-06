variable "network_mode" {
  default = "bridge"
}

variable "family" {
}

variable "task_template" {
}

variable "task_role_arn" {
}

variable "execution_role_arn" {
  default = ""
}

resource "aws_ecs_task_definition" "TaskDefinition" {
  family                = var.family
  container_definitions = var.task_template
  task_role_arn         = var.task_role_arn
  network_mode          = var.network_mode
  execution_role_arn    = var.execution_role_arn
}

output "TaskDefinitionARN" {
  value = join(" ", aws_ecs_task_definition.TaskDefinition.*.arn)
}

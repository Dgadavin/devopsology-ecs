data "terraform_remote_state" "main-cluster" {
  backend = "s3"

  config = {
    bucket = "devopsology-tf-max"
    key    = "${var.main_cluster_stack_name}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "es-cluster" {
  backend = "s3"

  config = {
    bucket = "devopsology-tf-max"
    key    = "${var.es_cluster_stack_name}/terraform.tfstate"
    region = "us-east-1"
  }
}

module "task-definition" {
  source        = "../../terraform-modules/task-definition"
  family        = var.service_name
  task_template = data.template_file.FluentServiceTemplate.rendered
  task_role_arn = module.iam-role.IAMRoleARN
  network_mode  = "host"
}

resource "aws_ecs_service" "main_cluster" {
  name                = var.service_name
  cluster             = data.terraform_remote_state.main-cluster.outputs.ClusterName
  task_definition     = module.task-definition.TaskDefinitionARN
  scheduling_strategy = "DAEMON"
}


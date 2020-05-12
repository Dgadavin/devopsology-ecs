data "aws_caller_identity" "current" {
}

data "template_file" "FluentServiceTemplate" {
  template = file("./templates/task_definition.json")

  vars = {
    aws_region   = "us-east-1"
    docker_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/fluent:1.0"
    service_name = var.service_name
    elk_url      = data.terraform_remote_state.es-cluster.outputs.ESEndpoint
  }
}


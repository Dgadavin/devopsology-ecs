data "terraform_remote_state" "main-cluster" {
  backend = "s3"

  config = {
    bucket = "@@bucket@@"
    key    = "${var.main_cluster_stack_name}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "base-stack" {
  backend = "s3"
  config = {
    bucket = "@@bucket@@"
    key    = "baseSetup/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "allow_ecs_cluster_to_es" {
  name        = "${var.main_cluster_stack_name}-to-es"
  description = "Allow ES access for to communicate with ${var.main_cluster_stack_name}"
  vpc_id      = data.terraform_remote_state.base-stack.outputs.VPCIdsMap[var.Environment]

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    security_groups = [
      data.terraform_remote_state.main-cluster.outputs.ClusterSecurityGroup,
    ]
  }
}

module "es_with_vpc" {
  source                         = "github.com/terraform-community-modules/tf_aws_elasticsearch"
  domain_name                    = "${var.service_name}-${var.Environment}"
  es_version                     = var.ESVersion
  create_iam_service_linked_role = var.Environment == "dev" ? true : false

  vpc_options = {
    security_group_ids = [aws_security_group.allow_ecs_cluster_to_es.id]
    subnet_ids         = [element(split(",", data.terraform_remote_state.base-stack.outputs.SubnetIdsMap[var.Environment]), 1)]
  }

  instance_count  = var.ESInstanceCount
  instance_type   = var.ESInstanceType
  ebs_volume_size = var.ElasticEBSize
}


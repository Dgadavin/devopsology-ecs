data "terraform_remote_state" "base-stack" {
  backend = "s3"
  config = {
    bucket = "@@bucket@@"
    key    = "baseSetup/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.ClusterName
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "template_file" "user_data" {
  template = file("templates/user_data.sh")

  vars = {
    cluster_name = var.ClusterName
  }
}

module "sns-drain-topic" {
  source     = "../terraform-modules//sns"
  topic_name = "${title(var.environment)}ClusterDrainEcsTopic"
}

module "alb-internal" {
  source   = "../terraform-modules//alb"
  alb_name = "${var.ClusterName}-internal"
  subnet_ids = split(
    ",",
    data.terraform_remote_state.base-stack.outputs.SubnetIdsMap[var.environment],
  )
  environment     = var.environment
  certificate_arn = var.CertificateARN
  security_group  = [aws_security_group.internal-load-balancer.id]
}

module "alb-external" {
  source   = "../terraform-modules//alb"
  alb_name = "${var.ClusterName}-external"
  subnet_ids = split(
    ",",
    data.terraform_remote_state.base-stack.outputs.SubnetIdsMap[var.environment],
  )
  environment     = var.environment
  certificate_arn = var.CertificateARN
  is_internal     = false
  security_group  = [aws_security_group.external-load-balancer.id]
}

module "ecs-instances" {
  source      = "../terraform-modules//autoscaling-group"
  environment = var.environment
  name        = var.ClusterName
  aws_ami     = var.AmiId
  # spot_price               = "0.017" # uncomment if you want to use spot instances
  instance_type            = "t2.micro"
  ssh_key_name             = var.ssh_key_name
  security_groups          = [aws_security_group.cluster-sg.id]
  iam_instance_profile_arn = module.instance-role.InstanceProfileARN
  subnet_ids = split(
    ",",
    data.terraform_remote_state.base-stack.outputs.SubnetIdsMap[var.environment],
  )
  lifecycle_hook  = false
  notify_target   = module.sns-drain-topic.SNSTopicARN
  notify_role_arn = module.asg-lifeccycle-hook-role.IAMRoleARN
  user_data       = data.template_file.user_data.rendered
}
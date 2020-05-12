output "ESClusterSG" {
  value = aws_security_group.allow_ecs_cluster_to_es.id
}

output "ESEndpoint" {
  value = module.es_with_vpc.endpoint
}


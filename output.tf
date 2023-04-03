output "service_resource_version" {
  value = "${kubernetes_service.default.metadata.0.resource_version}"
}

output "deployment_resource_version" {
  value = "${kubernetes_deployment.default.metadata.0.resource_version}"
}

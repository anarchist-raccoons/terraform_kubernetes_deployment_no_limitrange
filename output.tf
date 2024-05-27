output "service_resource_version" {
  value = kubernetes_service.default.metadata.0.resource_version
}

output "deployment_resource_version" {
  value = kubernetes_deployment.default.metadata.0.resource_version
}

# Display load balancer IP 
output "load_balancer_ip" {
  value = kubernetes_service.default.status.0.load_balancer.0.ingress.0.ip
}

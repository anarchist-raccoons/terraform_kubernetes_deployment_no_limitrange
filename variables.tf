variable "host" { }
variable "username" { }
variable "password" { }
variable "client_certificate" { }
variable "client_key" { }
variable "cluster_ca_certificate" { }
variable "docker_image" { }
variable "app_name" { }
variable "primary_port" { }
variable "secondary_port" { }

variable "env_from" { }

variable "command" {
  default = []
}

variable "primary_mount_path" {
}
variable "secondary_mount_path" {
}
variable "secondary_volume_name" {
  default = ""
}

variable "secondary_sub_path" {
  default = ""
}

variable "image_pull_secrets" {
}

variable "resource_version" {
  description = "Unused variable, used to create a dependency sequence."
  type = "list"
  default = []
}

variable "pvc_claim_name" {}
variable "secondary_pvc_claim_name" {
  default = ""
  }

variable "replicas" {
  default = 1
}

variable "load_balancer_source_ranges" {
  type = "list"
  default = []
}

variable "service_type" {
  default = "LoadBalancer"
}

variable "load_balancer_ip" {
  default = ""
}

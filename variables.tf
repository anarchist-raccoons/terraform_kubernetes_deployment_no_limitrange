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
  default = ""
}
variable "primary_mount_ro" {
  type    = bool
  default = false
}


variable "secondary_mount_path" {
  default = ""
}
variable "secondary_volume_name" {
  default = ""
}
variable "secondary_sub_path" {
  default = ""
}
variable "secondary_mount_ro" {
  type    = bool
  default = false
}

variable "tertiary_mount_path" {
    default = ""
}
variable "tertiary_volume_name" {
  default = ""
}
variable "tertiary_mount_ro" {
  type    = bool
  default = false
}

variable "image_pull_secrets" {
}

variable "resource_version" {
  description = "Unused variable, used to create a dependency sequence."
  type = list
  default = []
}

variable "pvc_claim_name" {}
variable "secondary_pvc_claim_name" {
  default = ""
  }
variable "tertiary_pvc_claim_name" {
  default = ""
  }

variable "replicas" {
  default = 1
}

variable "load_balancer_source_ranges" {
  type = list
  default = []
}

variable "service_type" {
  default = "LoadBalancer"
}

variable "load_balancer_ip" {
  default = ""
}

variable "node_selector_label" {
  default = ""
}

variable "fqdn" {
  default = ""
}

variable "startup" {
  type    = bool
  default = false
}

variable "secondary_mount" {
  type    = bool
  default = false
}

variable "tertiary_mount" {
  type    = bool
  default = false
}

variable "privileged" {
  type    = bool
  default = false
}

variable "available_externally" {
  type    = bool
  default = false
}

variable "not_available_externally" {
  type    = bool
  default = true
}

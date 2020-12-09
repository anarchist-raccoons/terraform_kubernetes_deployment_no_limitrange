provider "kubernetes" {
  load_config_file = false
  host = "${var.host}"
  username = "${var.username}"
  password = "${var.password}"
  client_certificate = "${var.client_certificate}"
  client_key = "${var.client_key}"
  cluster_ca_certificate = "${var.cluster_ca_certificate}"
}

resource "kubernetes_deployment" "default" {
  
  metadata {
    name = "${var.app_name}"
    labels = {
      app = "${var.app_name}"
    }
  }

  spec {
    replicas = "${var.replicas}"
  
    selector {
      match_labels = {
        app = "${var.app_name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.app_name}"
        }
      }

      spec {
        image_pull_secrets { 
          name = "${var.image_pull_secrets}"
        }

        container {
          image = "${var.docker_image}"
          name = "${var.app_name}"

          env_from {
            secret_ref {
              name = "${var.env_from}"
            }
          }
          
          volume_mount {
            name = "${var.app_name}"
            mount_path = "${var.primary_mount_path}"
          }
          volume_mount {
            name = "${var.secondary_volume_name}"
            mount_path = "${var.secondary_mount_path}"
            sub_path = "${var.secondary_sub_path}"
          }

          command = "${var.command}"
        }

        volume {
          name = "${var.app_name}"
          persistent_volume_claim {
          claim_name = "${var.pvc_claim_name}"
          }
        }
        volume {
          name = "${var.secondary_volume_name}"
          persistent_volume_claim {
          claim_name = "${var.secondary_pvc_claim_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "default" {
  metadata {
    name = "${var.app_name}"
    labels = {
      app = "${var.app_name}"
    }
  }
  spec {
    selector = {
      app = "${kubernetes_deployment.default.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    
    port {
      name        = "primary-port"
      port        = "${var.primary_port}"
      target_port = "${var.primary_port}"
    }

    port {
      name        = "secondary-port"
      port        = "${var.secondary_port}"
      target_port = "${var.secondary_port}"
    }

    
    load_balancer_ip = "${var.load_balancer_ip}"
    load_balancer_source_ranges = "${var.load_balancer_source_ranges}"

    type = "${var.service_type}"
  }
}

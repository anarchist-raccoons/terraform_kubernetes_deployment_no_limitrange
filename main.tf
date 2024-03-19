provider "kubernetes" {
  host = var.host
  username = var.username
  password = var.password
  client_certificate = var.client_certificate
  client_key = var.client_key
  cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_deployment" "default" {
  
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.replicas
  
    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        image_pull_secrets { 
          name = var.image_pull_secrets
        }
              
        node_selector = { app_group = var.node_selector_label }

        container {
          image = var.docker_image
          name = var.app_name

          env_from {
            secret_ref {
              name = var.env_from
            }
          }

          security_context {
            allow_privilege_escalation = false
            privileged = var.privileged
          }

          dynamic "startup_probe" { 
            for_each = var.startup ? [1] : []
            content {
              http_get {
                scheme = "HTTPS"
                host = var.fqdn
                path = "/"
                port = 443
              }
              initial_delay_seconds = 90
              period_seconds        = 30
              timeout_seconds       = 15
              failure_threshold     = 5
            }
          }

          volume_mount {
            name = var.app_name
            mount_path = var.primary_mount_path
            read_only = var.primary_mount_ro
          }
          
          dynamic "volume_mount" { 
            for_each = var.secondary_mount ? [1] : []
            content {
              name = var.secondary_volume_name
              mount_path = var.secondary_mount_path
              sub_path = var.secondary_sub_path
              read_only = var.secondary_mount_ro
            }
          }
          
          dynamic "volume_mount" { 
            for_each = var.tertiary_mount ? [1] : []
            content {
              name = var.tertiary_volume_name
              mount_path = var.tertiary_mount_path
              read_only = var.tertiary_mount_ro
            }
          }
          
          command = var.command
        }

        volume {
          name = var.app_name
          persistent_volume_claim {
            claim_name = var.pvc_claim_name
            read_only = var.primary_mount_ro
          }
        }
        
        dynamic "volume" {
          for_each = var.secondary_mount ? [1] : []
          content {
            name = var.secondary_volume_name
            persistent_volume_claim {
              claim_name = var.secondary_pvc_claim_name
              read_only = var.secondary_mount_ro
            }
          }
        }
        dynamic "volume" {
          for_each = var.tertiary_mount ? [1] : []
          content {
            name = var.tertiary_volume_name
            persistent_volume_claim {
              claim_name = var.tertiary_pvc_claim_name
              read_only = var.tertiary_mount_ro
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "default" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }
  dynamic "spec" {
    for_each = var.available_externally ? [1] : []
    contents {
      selector = {
        app = kubernetes_deployment.default.metadata.0.labels.app
      }
      session_affinity = "ClientIP"
    
      port {
        name        = "primary-port"
        port        = var.primary_port
        target_port = var.primary_port
      }

      port {
        name        = "secondary-port"
        port        = var.secondary_port
        target_port = var.secondary_port
      }
    
      load_balancer_ip = var.load_balancer_ip == true ? 1 : 0
      load_balancer_source_ranges = var.load_balancer_source_ranges

      external_traffic_policy = "Local"

      type = var.service_type
    }
  }
}

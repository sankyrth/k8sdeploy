resource "kubernetes_namespace" "example" {
  metadata {
    name = "k8s-wordpress-minikube-tf"
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "wordpress-deployment"
    labels = {
      app = "wordpressApp"
    }
    namespace = "k8s-wordpress-minikube-tf"
  }

  spec {
    replicas = 5

    selector {
      match_labels = {
        app = "wordpressApp"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpressApp"
        }
      }

      spec {
        container {
          image = "wordpressinc/wordpress-unprivileged:latest"
          name  = "wordpress"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "wordpress-service-np" {
  metadata {
    name = "wordpress-service-np"
  } 
  spec {
    selector = {
      app = "wordpressApp"
    } 
    session_affinity = "ClientIP"
    port {
      port      = 8080 
      node_port = 30085
    } 
    type = "NodePort"
  } 
} 
resource "kubernetes_pod_disruption_budget" "k8s-pdb-2" {
  metadata {
    name = "k8s-pdb-2"
  }
  spec {
    minAvailable = 2
    selector {
      match_labels = {
        app = "wordpressApp"
      }
    }
  }
}
resource "kubernetes_horizontal_pod_autoscaler" "example" {
  metadata {
    name = "k8s-hpa"
  }

  spec {
    max_replicas = 5
    min_replicas = 1

    scale_target_ref {
      kind = "Deployment"
      name = "wordpressApp"
    }
  }
}
resource "kubernetes_secret" "example" {
  metadata {
    name = "k8s-secret"
  }

  data = {
    name = "API_KEY"
  }

  type = "kubernetes.io/basic-auth"
}

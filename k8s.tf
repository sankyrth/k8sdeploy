resource "kubernetes_namespace" "example" {
  metadata {
    name = "k8s-nginx-minikube-tf"
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "nginx-deployment"
    labels = {
      app = "nginxApp"
    }
    namespace = "k8s-nginx-minikube-tf"
  }

  spec {
    replicas = 5

    selector {
      match_labels = {
        app = "nginxApp"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginxApp"
        }
      }

      spec {
        container {
          image = "nginxinc/nginx-unprivileged:latest"
          name  = "nginx"

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
resource "kubernetes_service" "nginx-service-np" {
  metadata {
    name = "nginx-service-np"
  } 
  spec {
    selector = {
      app = "nginxApp"
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
        app = "nginxApp"
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
      name = "nginxApp"
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

resource "kubernetes_config_map" "configmap" {
  metadata {
    name = "spotinst-kubernetes-cluster-controller-config"
    namespace = "kube-system"
  }

  data = {
    "spotinst.token" = "${var.spotinst_token}"
    "spotinst.account"  = "${var.spotinst_account}"
    "spotinst.cluster-identifier" = "${var.spotinst_cluster_identifier}"
  }
}

resource "kubernetes_secret" "default" {
  metadata {
    name = "spotinst-kubernetes-cluster-controller-certs"
    namespace = "kube-system"
    labels = {
      k8s-app = "spotinst-kubernetes-cluster-controller"
    }
  }
  type = "Opaque"
}

resource "kubernetes_service_account" "default" {
  metadata {
    name = "spotinst-kubernetes-cluster-controller"
    namespace = "kube-system"
    labels = {
      k8s-app = "spotinst-kubernetes-cluster-controller"
    }
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "default" {
  metadata {
    name = "spotinst-kubernetes-cluster-controller"
  }

  rule {
    api_groups = [""]
    resources = ["pods", "nodes", "replicationcontrollers", "events", "limitranges", "services", "persistentvolumes", "persistentvolumeclaims", "namespaces"]
    verbs = ["get", "delete", "list", "patch", "update", "create"]
  }

  rule {
    api_groups = [""]
    resources = ["pods/eviction"]
    verbs = ["create"]
  }

  rule {
    api_groups = ["apps"]
    resources = ["deployments", "daemonsets", "statefulsets"]
    verbs = ["get","list","patch","create","delete"]
  }

  rule {
    api_groups = ["extensions"]
    resources = ["replicasets", "daemonsets"]
    verbs = ["get","list","create","patch","delete"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources = ["clusterroles"]
    verbs = ["patch", "update"]
  }

  rule{
    api_groups = ["policy"]
    resources = ["poddisruptionbudgets"]
    verbs = ["list"]

  }

  rule {
    api_groups = ["metrics.k8s.io"]
    resources = ["pods"]
    verbs = ["list"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources = ["storageclasses"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources = ["jobs"]
    verbs = ["list"]
  }

  rule {
    non_resource_urls = ["/version/", "/version"]
    verbs = ["get"]
  }
}


resource "kubernetes_cluster_role_binding" "default" {
  metadata {
    name = "spotinst-kubernetes-cluster-controller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "spotinst-kubernetes-cluster-controller"
  }
  subject {
    api_group = ""
    kind = "ServiceAccount"
    name = "spotinst-kubernetes-cluster-controller"
    namespace = "kube-system"
  }
}



resource "kubernetes_deployment" "default" {
  metadata {
    name = "spotinst-kubernetes-cluster-controller"
    namespace = "kube-system"
    labels = {
      k8s-app = "spotinst-kubernetes-cluster-controller"
    }
  }

  spec {
    replicas = 1
    revision_history_limit = 10
    selector {
      match_labels = {
        k8s-app = "spotinst-kubernetes-cluster-controller"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "spotinst-kubernetes-cluster-controller"
        }
      }

      spec {

        container {
          image = "spotinst/kubernetes-cluster-controller:1.0.46"
          name  = "spotinst-kubernetes-cluster-controller"
          image_pull_policy = "Always"

          volume_mount {
            name = "spotinst-kubernetes-cluster-controller-certs"
            mount_path = "/certs"
          }
         
          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = "${kubernetes_service_account.default.default_secret_name}"
            read_only  = true
          }

          liveness_probe {

            http_get {
              path = "/healthcheck"
              port = 4401
            }
            initial_delay_seconds = 300
            period_seconds = 30

          }

          env {
            name = "SPOTINST_TOKEN"
            value_from {
              config_map_key_ref {
                name = "spotinst-kubernetes-cluster-controller-config"
                key = "spotinst.token"
              }
            }
          }
          env {
            name = "SPOTINST_ACCOUNT"
            value_from {
              config_map_key_ref {
                name = "spotinst-kubernetes-cluster-controller-config"
                key = "spotinst.account"
              }
            }
          }
          env {
            name = "CLUSTER_IDENTIFIER"
            value_from {
              config_map_key_ref {
                name = "spotinst-kubernetes-cluster-controller-config"
                key = "spotinst.cluster-identifier"
              }
            }
          }
        }

        volume {
          name = "spotinst-kubernetes-cluster-controller-certs"
          secret {
            secret_name = "spotinst-kubernetes-cluster-controller-certs"
          }
        }
      


        volume {
          name = "${kubernetes_service_account.default.default_secret_name}"
          secret {
            secret_name = "${kubernetes_service_account.default.default_secret_name}"
          }
        }

        service_account_name = "spotinst-kubernetes-cluster-controller"
      }
    }
  }
}

data "external" "version" {
  program = ["curl", "https://spotinst-public.s3.amazonaws.com/integrations/kubernetes/cluster-controller/latest.json"]
}

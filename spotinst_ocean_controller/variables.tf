variable "host" {
  description = "The hostname (in form of URI) of Kubernetes master. Can be sourced from KUBE_HOST. Defaults to https://localhost."
  default = ""
}

variable "username" {
  description = "The username to use for HTTP basic authentication when accessing the Kubernetes master endpoint. Can be sourced from KUBE_USER."
  default = ""
}

variable "password" {
  description = "The password to use for HTTP basic authentication when accessing the Kubernetes master endpoint. Can be sourced from KUBE_PASSWORD."
  default = ""
}

variable "config_context_cluster" {
  description = "Cluster context of the kube config (name of the kubeconfig cluster, --cluster flag in kubectl)."
  default = ""
}

variable "spotinst_token" {
  description = "The token used when accessing your Spotinst account"
}

variable "spotinst_account" {
  description = "Your Spotinst account"
}

variable "spotinst_cluster_identifier" {
  description = "This identifier should be identical to the clusterIdentifier that was configured on the Elastigroup."
}

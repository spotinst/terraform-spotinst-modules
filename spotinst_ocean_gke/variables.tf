variable "spotinst_token" {
  description = "The spotinst token used for the controller configMap"
}

variable "spotinst_account" {
  description = "The spotinst account-id used for the controller configMap"
}

variable "project_id" {
    description = "Your GCP project ID"
}

variable "is_regional" {
    description = "Set to true if you want to create a regional cluster"
    type = bool
    default = false
}

variable "cluster_name" {
    description = "The GKE and Ocean cluster name"
}

variable "region" {
    description = "The region which the cluster will reside in"
}

variable "zones" {
  type        = list(string)
  description = "The zone to host the cluster in (required if is a zonal cluster)"
}

variable "network" {
  description = "The VPC network to host the cluster in"
  default = "default"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  default = "default"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  default = ""
}

variable "ip_range_services" {
  description = "The secondary ip range to use for pods"
  default = ""
}

variable "http_load_balancing" {
  description = "Enable httpload balancer addon"
  type = bool
  default = true
}

variable "horizontal_pod_autoscaling" {
  description = "Enable horizontal pod autoscaling addon"
  type = bool
  default = true
}

variable "network_policy" {
  description = "Enable network policy addon"
  type = bool
  default = true
}

variable "create_service_account" {
  description = "Default value (true) will cause a cluster-specific service account to be created."
  type = bool
  default = true
}
variable "compute_engine_service_account" {
  description = "Service account to associate to the nodes in the cluster"
}

variable "skip_provisioners" {
  type        = bool
  description = "Flag to skip local-exec provisioners"
  default     = false
}

variable "location" {
  description = "Cluster location, should be either the region or the zone"
}

variable "kubernetes_version" {
    description = "The GKE Kubernetes version"
    default = "latest"
}

variable "monitoring_service" {
    description = "The monitoring service to attach to the cluster, should be one of the following values: monitoring.googleapis.com, monitoring.googleapis.com/kubernetes and none"
    default = "monitoring.googleapis.com/kubernetes"
}         

variable "logging_service" {
    description = "The logging service to attach to the cluster, logging.googleapis.com, logging.googleapis.com/kubernetes and none"   
    default = "logging.googleapis.com/kubernetes"
}
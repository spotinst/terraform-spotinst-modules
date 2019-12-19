provider "google" {
  version = "~> 2.18.0"
  region  = var.region
}

provider "spotinst" {
   token   = var.spotinst_token
   account = var.spotinst_account
}

module "spotinst_ocean-gke" {
    source = "../"
    spotinst_token   = var.spotinst_token
    spotinst_account = var.spotinst_account
    project_id = var.project_id
    is_regional = var.is_regional
    cluster_name = var.cluster_name
    region = var.region
    zones = var.zones    
    location = var.location
    network = var.network
    subnetwork = var.subnetwork
    ip_range_pods = var.ip_range_pods
    ip_range_services = var.ip_range_services
    create_service_account     = var.create_service_account
    compute_engine_service_account = var.compute_engine_service_account
    skip_provisioners = var.skip_provisioners
    http_load_balancing        = var.http_load_balancing
    horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
    network_policy             = var.network_policy
    kubernetes_version = var.kubernetes_version
    monitoring_service = var.monitoring_service
    logging_service = var.logging_service
}
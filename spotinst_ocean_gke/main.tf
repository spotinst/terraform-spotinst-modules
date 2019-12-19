# Regional
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = var.cluster_name
  regional                   = var.is_regional
  region                     = var.region
  zones                      = var.zones
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  create_service_account     = var.create_service_account
  service_account            = var.compute_engine_service_account
  skip_provisioners          = var.skip_provisioners
  http_load_balancing        = var.http_load_balancing
  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
  network_policy             = var.network_policy
  monitoring_service         = var.monitoring_service
  logging_service            = var.logging_service
  kubernetes_version         = var.kubernetes_version
}

data "google_client_config" "default" {
}

# Creating the Ocean cluster
resource "spotinst_ocean_gke_import" "ocean-gke" {
  cluster_name = var.cluster_name
  location     = var.location

  min_size = 1
  max_size = 100
  desired_capacity = 1

  whitelist = ["n1-standard-1", 
               "n1-standard-2",
               "n1-standard-4",
               "n1-standard-8",
               "n1-standard-16",
               "n1-standard-32",
               "n1-standard-64",
               "n1-standard-96",
               "n1-highmem-2",
               "n1-highmem-4",
               "n1-highmem-8",
               "n1-highmem-16",
               "n1-highmem-32",
               "n1-highmem-64",
               "n1-highmem-96",
               "n1-highcpu-8",
               "n1-highcpu-16",
               "n1-highcpu-32",
               "n1-highcpu-64",
               "n1-highcpu-96",
               "n1-ultramem-40",
               "n1-ultramem-80",
               "n1-megamem-96",
               "c2-standard-4",
               "c2-standard-8",
               "c2-standard-16",
               "c2-standard-30",
               "c2-standard-60",
               "n2-standard-2",
               "n2-standard-4",
               "n2-standard-8",
               "n2-standard-16",
               "n2-standard-32",
               "n2-standard-48",
               "n2-standard-64",
               "n2-standard-80",
               "n2-highmem-2",
               "n2-highmem-4",
               "n2-highmem-8",
               "n2-highmem-16",
               "n2-highmem-32",
               "n2-highmem-48",
               "n2-highmem-64",
               "n2-highmem-80",
               "n2-highcpu-4",
               "n2-highcpu-8",
               "n2-highcpu-16",
               "n2-highcpu-32",
               "n2-highcpu-48",
               "n2-highcpu-64",
               "n2-highcpu-80"
               ]

  depends_on = [ module.gke ]
}

# Running the spotinst-kubernetes-cluster-controller on the cluster
resource "null_resource" "controller_installation" {
  depends_on = [module.gke, spotinst_ocean_gke_import.ocean-gke]

  provisioner "local-exec" {
    command = <<EOT
      gcloud container clusters get-credentials ${var.cluster_name} --region ${var.location}

      if [ ! -z ${var.spotinst_account} -a ! -z ${var.spotinst_token} ]; then
        echo "Downloading controller configMap"
        curl https://spotinst-public.s3.amazonaws.com/integrations/kubernetes/cluster-controller/templates/spotinst-kubernetes-controller-config-map.yaml -o configMap.yaml
        echo "Finished downloading controller configMap"
        sed -i -e "s@<TOKEN>@${var.spotinst_token}@g" configMap.yaml
        sed -i -e "s@<ACCOUNT_ID>@${var.spotinst_account}@g" configMap.yaml
        sed -i -e "s@<IDENTIFIER>@${spotinst_ocean_gke_import.ocean-gke.cluster_controller_id}@g" configMap.yaml
        echo "Creating controller configMap in k8s"
        kubectl create -f configMap.yaml
        echo "Created controller configMap in k8s. creating controller resources"
        kubectl create -f https://s3.amazonaws.com/spotinst-public/integrations/kubernetes/cluster-controller/spotinst-kubernetes-cluster-controller-ga.yaml
        echo "Controller installed"
      else 
        echo "Account id and token has not been provided, therefore the spotinst-controller will not be created"
      fi
    EOT
  }
}

# Resizing all node-pools to 0
resource "null_resource" "remove_node_pools_capacity" {
  depends_on = [module.gke, spotinst_ocean_gke_import.ocean-gke, null_resource.controller_installation]
  provisioner "local-exec" {
    command = <<EOT
      gcloud container clusters get-credentials ${var.cluster_name} --region ${var.location}
      gcloud container node-pools list --cluster amit-test --region ${var.location} | sed 's/|/ /' | awk '{print $1}' > node-pools.txt
      chmod +x ../scripts/resize_nodepools.sh
      ../scripts/resize_nodepools.sh ${var.cluster_name} ${var.location}
    EOT
  }
}
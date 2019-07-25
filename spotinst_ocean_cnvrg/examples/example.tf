provider "aws" {
  version = ">= 1.47.0"
  region  = "${var.region}"
}

// used when creating EKS cluster name
provider "random" {
  version = "= 1.3.1"
}

provider "spotinst" {
   token   = "${var.spotinst_token}"
   account = "${var.spotinst_account}"
}

module "spotinst_ocean_cnvrg" {
  source = "github.com/spotinst/terraform-spotinst-modules//spotinst_ocean_cnvrg"
  
  spotinst_token = "${var.spotinst_token}"
  spotinst_account = "${var.spotinst_account}"
  ocean_cluster_name = "${var.ocean_cluster_name}"
  controller_id      = "${var.controller_id}"
  region             = "${var.region}"

  min_size         = "${var.min_size}"
  max_size         = "${var.max_size}"
  desired_capacity = "${var.min_size}"

  ami         = "${var.ami}"
  key_name    = "${var.key_name}"

  cnvrg_app_domain="${var.cnvrg_app_domain}"
  cnvrg_user_name="${var.cnvrg_user_name}"
  cnvrg_user_password="${var.cnvrg_user_password}"
  cnvrg_user_email="${var.cnvrg_user_email}"
  cnvrg_user_org="${var.cnvrg_user_org}"
  cnvrg_user_access_key="${var.cnvrg_user_access_key}"
  cnvrg_user_secret_key="${var.cnvrg_user_secret_key}"
  cnvrg_storage_bucket_name="${var.cnvrg_storage_bucket_name}"
  cnvrg_storage_bucket_region="${var.cnvrg_storage_bucket_region}"
}

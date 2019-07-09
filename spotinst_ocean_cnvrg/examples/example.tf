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
}

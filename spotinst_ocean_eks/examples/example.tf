provider "aws" {
  version = ">= 1.47.0"
  region  = "us-west-2"
}

provider "random" {
  version = "= 1.3.1"
}

provider "spotinst" {
   token   = "your token"
   account = "your account"
}

module "spotinst_ocean_eks" {
  source = "github.com/alexindeed/terraform-spotinst-modules//spotinst_ocean_eks"

  ocean_cluster_name = "my_ocean_cluster"
  controller_id      = "my_cluster_id"
  region             = ""

  min_size         = 1
  max_size         = 5
  desired_capacity = 3

  ami         = ""
  key_name    = ""
  environment = ""
}


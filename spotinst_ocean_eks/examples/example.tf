provider "aws" {
  version = ">= 1.47.0"
  region  = "us-west-2"
}

// used when creating EKS cluster name
provider "random" {
  version = "= 1.3.1"
}

provider "spotinst" {
   token   = "your spotisnt token"
   account = "your spotinst account id"
}

module "spotinst_ocean_eks" {
  source = "github.com/spotinst/terraform-spotinst-modules//spotinst_ocean_eks"

  ocean_cluster_name = "example-test-cluster"
  controller_id      = "example-cluster-id"
  region             = "us-west-2"

  min_size         = 1
  max_size         = 5
  desired_capacity = 3

  ami         = "ami-0923e4b35a30a5f53"
  key_name    = "example-ssh-key-name"
}
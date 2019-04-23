provider "aws" {
  version = ">= 1.47.0"
  region  = ""
}

provider "random" {
  version = "= 1.3.1"
}

provider "spotinst" {
   token   = "your token"
   account = "your account"
}

module "spotinst_ocean_eks" {
  source = "github.com/spotinst/terraform-spotinst-modules//spotinst_ocean_eks/?ref=v1.0.0"

  ocean_cluster_name = "my_ocean_cluster"
  controller_id      = "my_cluster_id"

  min_size         = 1
  max_size         = 5
  desired_capacity = 3

  ami         = "ami-05ecac759c81e0b0c"
  key_name    = "my-ssh-key"
  environment = "dev"
}


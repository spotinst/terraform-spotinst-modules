provider "aws" {
  version = ">= 1.47.0"
  region  = "us-east-1"
}

module "spotinst_eco_aws_iam" {
  # To pull from GitHub
  source = "github.com/spotinst/terraform-spotinst-modules//spotinst_eco_aws_iam"

  # For local use
  # source = "../"

  # Define Variables
  cost_usage_bucket = "replace-with-cost-and-usage-bucket"
}

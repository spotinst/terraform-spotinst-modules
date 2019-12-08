provider "kubernetes" {
  config_context_cluster = ""

  # host     = ""
  # username = ""
  # password = ""
}

module "spotinst_ocean_controller" {
  source = "github.com/spotinst/terraform-spotinst-modules//spotinst_ocean_controller/?ref=v1.0.1"

  spotinst_account            = "act-123456"
  spotinst_token              = "<my_token>"
  spotinst_cluster_identifier = ""
}

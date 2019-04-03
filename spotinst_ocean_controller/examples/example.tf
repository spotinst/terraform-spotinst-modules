
########################################################################
# general purpose example
########################################################################

module "spotinst_ocean_controller" {
  source = "github.com/spotinst/terraform-spotinst-modules//spotinst_ocean_controller/?ref=v0.1.0"

  config_context_cluster = ""

  # host = ""
  # username = ""
  # password = ""

  spotinst_account = "act-123456"
  spotinst_token = "<my_token>"
  spotinst_cluster_identifier = ""
}
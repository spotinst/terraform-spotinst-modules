# Spotinst Terraform Modules
This repo contains reusable terraform modules developed in-house at Spotinst.

## Using Modules
If you are new to Terraform Modules, check out Hashicorp's [quick overview.](https://learn.hashicorp.com/terraform/getting-started/modules)

1. To use a module from this repository, add a block like the following to your terraform code:
```
module "example" {
  source = "github.com/spotinst/terraform-spotinst-modules//example?ref=v0.1.0"

  param     = "foo"
  param_two = "bar"
}
```
2. Ensure that the ref above corresponds to an existing release tag in this repository.
3. Run terraform get to acquire the module.
4. Run terraform plan to preview changes.

## Feedback
If there's a feature, new module, or change you'd like to see - let us know! 
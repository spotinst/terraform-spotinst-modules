# spotinst_ocean_controller

This module will install the [Spotinst Kubernetes Controller][controller-api-url] for use when importing and managing clusters using Elastigroups with Spotinst Ocean. More information can be found in the offical [Spotinst Kubernetes Documentation][spotinst-k8s-api-url]

This module manages the following resources:
* aws provider
	* aws_iam_role
	* aws_iam_policy
	* aws_iam_policy_attachment

## Variables
* cost_usage_bucket
* access_type

## Example Use
Fill in the following arguments in example.tf:
```
module "spotinst_eco_aws_iam" {
  source = "github.com/spotinst/terraform-spotinst-modules//spotinst_eco_aws_iam"

  cost_usage_bucket = "s3-bucket-with-cost-and-usage-report"
  access_type = "ro"
}
```

From within ./example, run the following commands:
```
terraform get
terraform init
terrafomr apply
```

You will see "Apply complete!" if your plan is applied successfully.


[controller-api-url]: https://api.spotinst.com/container-management/kubernetes/kubernetes-tutorials/spotinst-kubernetes-controller/
[spotinst-k8s-api-url]: https://api.spotinst.com/container-management/kubernetes/

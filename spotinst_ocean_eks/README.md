# spotinst_ocean_eks

This module will create a new AWS EKS cluster and link it to a newly created Spotinst Ocean cluster in your account.

## Variables
* ocean_cluster_name
* controller_id
* region
* min_size
* max_size
* desired_capacity
* ami
* key_name

## Example Use
Fill in the following arguments in example.tf:
```
module "spotinst_ocean_eks" {
  source = "github.com/alexindeed/terraform-spotinst-modules//spotinst_ocean_eks"

  ocean_cluster_name = "example-test-cluster"
  controller_id      = "example-cluster-id"
  region             = "us-west-2"

  min_size         = 1
  max_size         = 5
  desired_capacity = 3

  ami         = "ami-0923e4b35a30a5f53"
  key_name    = "example-ssh-key-name"
}
```

From within ./example, run the following commands:
```
terraform get
terraform init
terraform apply
```

You will see "Apply complete!" if your plan is applied successfully. You will need to install the Spotinst Ocean controller in order to see node status updates.

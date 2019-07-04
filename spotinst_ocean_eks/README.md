# spotinst_ocean_eks

This module will create a new AWS EKS cluster and link it to a newly created Spotinst Ocean cluster in your account.
The module will install the Spotinst Kuberentes controller on top of the cluster.

## Example Use
Go to the examples dir.
Fill the variables.tf file.

## Variables
* ocean_cluster_name
* controller_id
* region
* min_size (should be at-least 1)
* max_size
* ami
* key_name
* spotinst_token
* spotinst_account

From within ./examples, run the following commands:
```
terraform get
terraform init
terraform apply
```

You will see "Apply complete!" if your plan is applied successfully. You will need to install the Spotinst Ocean controller in order to see node status updates.

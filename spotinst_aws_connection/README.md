# spotinst_aws_connection

This module setups all IAM resources that are necessary to connect a Spotinst account to an AWS account.

## Example Use

```
module "spotinst_aws_connection" {
  source = "github.com/spotinst/terraform-spotinst-modules//spotinst_aws_connection/?ref=v0.2.0"

  spotinst_account_id = ""
  spotinst_external_id = ""
}
```

## Variables

Enter as provided during account creation in the Spotinst web interface.

* spotinst_account_id
* spotinst_external_id

## Outputs

You will need this to enter the role in the Spotinst web interface.

* spotinst_role_arn

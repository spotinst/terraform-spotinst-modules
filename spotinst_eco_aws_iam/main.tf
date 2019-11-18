resource "aws_iam_role" "spotinst_eco_role" {
  name        = "spotinst-eco-role"
  description = "Spotinst Eco access for RI management"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "AWS": ["arn:aws:iam::393649089167:root",
                        "arn:aws:iam::884866656237:root"]
              },
              "Action": "sts:AssumeRole"
            }
          ]
}
EOF
}

resource "aws_iam_policy" "spotinst_eco_policy" {
  name        = "spotinst-eco-policy"
  path        = "/"
  description = "Spotinst Eco Policy"
  policy      = "${data.aws_iam_policy_document.spotinst_eco_policy_read.json}"
}

resource "aws_iam_policy_attachment" "spotinst_eco_policy_attachment" {
  name       = "spotinst-eco-policy-attachment"
  roles      = ["${aws_iam_role.spotinst_eco_role.name}"]
  policy_arn = "${aws_iam_policy.spotinst_eco_policy.arn}"
}

resource "aws_iam_policy_attachment" "spotinst_eco_billing_attachment" {
  name       = "spotinst-eco-policy-attachment"
  roles      = ["${aws_iam_role.spotinst_eco_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_policy_attachment" "spotinst_eco_cloudformation_read_attachment" {
  name       = "spotinst-eco-policy-attachment"
  roles      = ["${aws_iam_role.spotinst_eco_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "spotinst_eco_ec2_read_attachment" {
  name       = "spotinst-eco-policy-attachment"
  roles      = ["${aws_iam_role.spotinst_eco_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

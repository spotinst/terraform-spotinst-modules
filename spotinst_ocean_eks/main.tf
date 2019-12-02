terraform {
  required_version = ">= 0.11.7"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "ocean-eks-${random_string.suffix.result}"

  tags = {}
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "1.60.0"
  name               = "${local.cluster_name}"
  cidr               = "10.0.0.0/16"
  azs                = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags               = "${merge(local.tags, map("kubernetes.io/cluster/${local.cluster_name}", "shared"))}"
}

resource "aws_iam_role" "workers" {
  name_prefix           = "${local.cluster_name}"
  assume_role_policy    = "${data.aws_iam_policy_document.workers_assume_role_policy.json}"
  force_detach_policies = true
}

resource "aws_iam_instance_profile" "workers" {
  name_prefix = "${local.cluster_name}"
  role        = "${aws_iam_role.workers.name}"
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.workers.name}"
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.workers.name}"
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.workers.name}"
}

module "eks" {
  version            = "v4.0.2" # requiered for terraform version < 0.12
  source             = "terraform-aws-modules/eks/aws"
  cluster_name       = "${local.cluster_name}"
  cluster_version    = "${var.cluster_version}"
  subnets            = ["${module.vpc.private_subnets}"]
  tags               = "${local.tags}"
  vpc_id             = "${module.vpc.vpc_id}"
  worker_group_count = 0

  map_roles_count = 1

  map_roles = [
    {
      role_arn = "${aws_iam_role.workers.arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      group    = "system:nodes"
    },
  ]

  worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
}

resource "spotinst_ocean_aws" "tf_ocean_cluster" {
  name                        = "${var.ocean_cluster_name}"
  controller_id               = "${var.controller_id}"
  region                      = "${var.region}"
  max_size                    = "${var.max_size}"
  min_size                    = "${var.min_size}"
  desired_capacity            = "${var.desired_capacity}"
  subnet_ids                  = ["${module.vpc.private_subnets}"]
  image_id                    = "${var.ami}"
  security_groups             = ["${aws_security_group.all_worker_mgmt.id}", "${module.eks.worker_security_group_id}"]
  key_name                    = "${var.key_name}"
  associate_public_ip_address = false

  user_data = <<-EOF
      #!/bin/bash
      set -o xtrace
      /etc/eks/bootstrap.sh ${local.cluster_name}
      EOF

  iam_instance_profile = "${aws_iam_instance_profile.workers.arn}"

  tags = [
    {
      key   = "Name"
      value = "${local.cluster_name}-ocean_cluster-Node"
    },
    {
      key   = "kubernetes.io/cluster/${local.cluster_name}"
      value = "owned"
    },
  ]

  autoscaler = {
    autoscale_is_enabled     = true
    autoscale_is_auto_config = false
    autoscale_cooldown       = 300

    autoscale_down = {
      evaluation_periods = 300
    }

    resource_limits = {
      max_vcpu       = 1000
      max_memory_gib = 2000
    }
  }

  depends_on = ["module.eks"]
}

resource "null_resource" "controller_installation" {
  depends_on = ["module.eks", "spotinst_ocean_aws.tf_ocean_cluster"]

  provisioner "local-exec" {
    command = <<EOT
      if [ ! -z ${var.spotinst_account} -a ! -z ${var.spotinst_token} ]; then
        echo "Downloading controller configMap"
        curl https://spotinst-public.s3.amazonaws.com/integrations/kubernetes/cluster-controller/templates/spotinst-kubernetes-controller-config-map.yaml -o configMap.yaml
        echo "Finished downloading controller configMap"
        sed -i -e "s@<TOKEN>@${var.spotinst_token}@g" configMap.yaml
        sed -i -e "s@<ACCOUNT_ID>@${var.spotinst_account}@g" configMap.yaml
        sed -i -e "s@<IDENTIFIER>@${var.controller_id}@g" configMap.yaml
        echo "Creating controller configMap in k8s"
        kubectl --kubeconfig=${module.eks.kubeconfig_filename} create -f configMap.yaml
        echo "Created controller configMap in k8s. creating controller resources"
        kubectl --kubeconfig=${module.eks.kubeconfig_filename} create -f https://s3.amazonaws.com/spotinst-public/integrations/kubernetes/cluster-controller/spotinst-kubernetes-cluster-controller-ga.yaml
        echo "Controller installed"
      else 
        echo "Account id and token has not been provided, therefore the spotinst-controller will not be created"
      fi
    EOT
  }
}

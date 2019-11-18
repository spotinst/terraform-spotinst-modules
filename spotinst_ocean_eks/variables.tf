variable "region" {
  description = "The region the EKS cluster will be located."
}

variable "ami" {
  description = "An AMI that is compatible with your desired version of kubernetes."
}

variable "cluster_version" {
  description = "Kubernetes supported version."
  default     = "1.12"
}

variable "ocean_cluster_name" {
  description = "The name you would like associated with your ocean cluster."
}

variable "controller_id" {
  description = "The ID you would like associated with the controller node."
}

variable "min_size" {
  description = "The lower limit of instances the cluster can scale down to."
}

variable "max_size" {
  description = "The upper limit of instances the cluster can scale up to."
}

variable "desired_capacity" {
  description = "The number of instances to launch and maintain in the cluster."
}

variable "key_name" {
  description = "The key pair to attach the instances."
}

variable "spotinst_token" {
  description = "The Spotinst token used by the controller."
  default     = ""
}

variable "spotinst_account" {
  description = "The Spotinst account ID used by the controller."
  default     = ""
}

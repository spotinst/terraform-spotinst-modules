variable "region" {
  description = "The region the EKS cluster will be located."
}

variable "ami" {
  description = "An ami that is compatible with your desired version of kubernetes."
}

variable "cluster_version" {
  description = "EKS k8s supported version"
  default = "1.12"
}

variable "ocean_cluster_name" {
  description = "The name you would like associated with your ocean cluster."
}

variable "controller_id" {
  description = "The id you would like associated with the controller node."
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
  description = "The spotinst token used for the controller configMap"
  default = ""  
}

variable "spotinst_account" {
  description = "The spotinst account-id used for the controller configMap"
  default = ""
}

variable "cnvrg_app_domain" {
  default = "default_cnvrg_app_domain"
}

variable "cnvrg_user_name" {
  default = "default_cnvrg_user_name"
}

variable "cnvrg_user_password" {
  default = "default_cnvrg_user_password"
}

variable "cnvrg_user_email" {
  default = "default_cnvrg_user_email"
}

variable "cnvrg_user_org" {
  default = "default_cnvrg_user_org"
}

variable "cnvrg_user_access_key" {
  default = "default_cnvrg_user_access_key"
}

variable "cnvrg_user_secret_key" {
  default = "default_cnvrg_user_secret_key"
}

variable "cnvrg_storage_bucket_name" {
  default = "default_cnvrg_storage_bucket_name"
}

variable "cnvrg_storage_bucket_region" {
  default = "default_cnvrg_storage_bucket_region"
}
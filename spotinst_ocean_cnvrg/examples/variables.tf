variable "spotinst_token" {
  default = "your_token"
}

variable "spotinst_account" {
  default = "your_account"
}

variable "region" {
  default = "us-west-2"
}

variable "ami" {
  default = "ami-0923e4b35a30a5f53"
}

variable "key_name" {
  default = "your_key_name"
}

variable "ocean_cluster_name" {
  default = "default_cluster_name"
}

variable "controller_id" {
  default = "default_controller_id"
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

variable "min_size" {
  default = 1
  description = "Should be at least 1"
}

variable "max_size" {
  default = 1000
}

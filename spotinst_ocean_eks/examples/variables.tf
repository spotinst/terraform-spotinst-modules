variable "spotinst_token" {
  default = "your_token"
}

variable "spotinst_account" {
  default = "your_account""
}

variable "region" {
  default = "us-west-2"
}

variable "ami" {
  default = "ami-0923e4b35a30a5f53"
}

variable "keyname" {
  default = "your_key_name"
}

variable "ocean_cluster_name" {
  default = "cluster_name"
}

variable "controller_id" {
  default = "controller_id"
}

variable "min_size" {
  default = 1
  description = "Should be at least 1"
}

variable "max_size {
  default = 1000
}

variable "spotinst_token" {
  description = "Your Spotinst Personal Access token"
}

variable "spotinst_account" {
  description = "Your Spotinst account ID"
}

variable "spotinst_cluster_identifier" {
  description = "Your cluster identifier"
}

variable "base_url" {
  description = "Base URL to be used by the HTTP client"
  default     = ""
}

variable "proxy_url" {
  description = "Proxy server URL to communicate through"
  default     = ""
}

variable "enable_csr_approval" {
  description = "Enable the CSR approval feature"
  default     = false
}

variable "disable_auto_update" {
  description = "Disable the auto-update feature"
  default     = false
}

variable "cost_usage_bucket" {
  description = "The bucket name of where the *HOURLY* Cost and Usage Report is located. https://console.aws.amazon.com/billing/home?#/reports"
}

variable "access_type" {
  description = "ro | full"
  default     = "ro"
}

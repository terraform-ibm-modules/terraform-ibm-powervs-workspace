variable "pi_workspace_guid" {
  description = "Existing IBM Cloud PowerVS Workspace GUID."
  type        = string
}

variable "pi_private_subnet_ids" {
  description = "List of IBM Cloud PowerVS subnet ids to be attached to Cloud connection. Maximum of 3 subnets in a list are supported."
  type        = list(any)
  validation {
    condition     = length(var.pi_private_subnet_ids) > 3 ? false : true
    error_message = "Maximum length of list can be 3 only. Supports only 3 subnet ids."
  }
}

variable "pi_cloud_connection_count" {
  description = "Number of cloud connections where private networks should be attached to. Default is to use redundant cloud connection pair."
  type        = number
}

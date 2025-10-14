################################
# Resource group module variable
################################

variable "powervs_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision resources in to. If not set a new resource group will be created using the prefix variable"
  default     = null
}

####################################
# PowerVS Workspace module variables
###################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key used to authenticate the IBM Cloud provider."
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources ."
}

variable "powervs_zone" {
  description = "IBM Cloud PowerVS zone where the PowerVS workspace will be created."
  type        = string
}

variable "powervs_workspace_name" {
  description = "Provide unique name for the PowerVS workspace to be created."
  type        = string
  default     = "powervs-workspace"
}

variable "powervs_ssh_public_key" {
  description = "Value of the Public SSH key to create inside the PowerVS workspace."
  type        = string
}

variable "powervs_private_subnet_1" {
  description = "IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name          = string
    cidr          = string
    advertise     = optional(string)
    arp_broadcast = optional(string)
  })
  default = {
    name = "sub_1"
    cidr = "10.51.0.0/24"
  }
}

variable "powervs_private_subnet_2" {
  description = "IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name          = string
    cidr          = string
    advertise     = optional(string)
    arp_broadcast = optional(string)
  })
  default = {
    name = "sub_2"
    cidr = ""
  }
}
variable "powervs_private_subnet_3" {
  description = "IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name          = string
    cidr          = string
    advertise     = optional(string)
    arp_broadcast = optional(string)
  })
  default = {
    name = "sub_3"
    cidr = ""
  }
}
variable "powervs_public_network_enable" {
  description = "IBM Cloud PowerVS Public Network. Set to true to enable this."
  type        = bool
  default     = false
}

variable "powervs_tags" {
  description = "List of Tag names for IBM Cloud PowerVS workspace."
  type        = list(string)
  default     = ["custom-workspace"]
}

variable "create_transit_gateway" {
  description = "Set to true to create a Transit Gateway for the PowerVS workspace and attach it."
  type        = bool
  default     = true
}

variable "pi_custom_images" {
  description = <<EOF
    Optional list of custom images to import from Cloud Object Storage into PowerVS workspace.
      image_name: string, must be unique image name how the image will be named inside PowerVS workspace
      file_name: string, full file name of the image inside COS bucket
      storage_tier: string, storage tier which the image will be stored in after import. Supported values are: "tier0", "tier1", "tier3", "tier5k".
      sap_type: optional string, "Hana", "Netweaver", don't use it for non-SAP image.
  EOF
  type = list(object({
    image_name   = string
    file_name    = string
    storage_tier = string
    sap_type     = optional(string)
    }
    )
  )
  default = []
}

variable "powervs_custom_image_cos_configuration" {
  description = <<EOF
    Cloud Object Storage bucket containing the custom PowerVS images. Images will be imported into the PowerVS Workspace.
      bucket_name: string, name of the COS bucket
      bucket_access: string, possible values: "public", "private" (private requires powervs_custom_image_cos_service_credentials)
      bucket_region: string, COS bucket region
  EOF
  type = object({
    bucket_name   = string
    bucket_access = string
    bucket_region = string
  })
  default = null
  validation {
    condition     = var.powervs_custom_image_cos_configuration != null ? contains(["public", "private"], var.powervs_custom_image_cos_configuration.bucket_access) : true
    error_message = "Invalid powervs_custom_image_cos_configuration.bucket_access. Allowed values: [\"public\", \"private\"]."
  }
  validation {
    condition = (
      length(var.pi_custom_images) == 0 || var.powervs_custom_image_cos_configuration != null
    )
    error_message = "The import of custom images into PowerVS workspace requires a COS configuration."
  }
}

variable "powervs_custom_image_cos_service_credentials" {
  description = "Service credentials for the Cloud Object Storage bucket containing the custom PowerVS images. The bucket must have HMAC credentials enabled. Click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials) for a json example of a service credential."
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.powervs_custom_image_cos_configuration != null ? var.powervs_custom_image_cos_configuration.bucket_access == "private" ? var.powervs_custom_image_cos_service_credentials != null : true : true
    error_message = "powervs_custom_image_cos_service_credentials are required to access private COS buckets."
  }
}

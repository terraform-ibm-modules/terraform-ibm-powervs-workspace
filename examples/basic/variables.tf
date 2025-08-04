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
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
}

variable "powervs_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
}

variable "powervs_workspace_name" {
  description = "Name of IBM Cloud PowerVS workspace which will be created."
  type        = string
  default     = "powervs-workspace"
}

variable "powervs_ssh_public_key" {
  description = "Value of the Public SSH key to create."
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
    cidr = "10.53.0.0/24"
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
  default     = ["pi-basic"]
}

variable "create_transit_gateway" {
  description = "Set to true to create a Transit Gateway for the PowerVS workspace and attach it."
  type        = bool
  default     = true
}

variable "powervs_custom_image1" {
  description = <<EOF
    Optional custom image to import from Cloud Object Storage into PowerVS workspace.
      image_name: string, must be unique image name how the image will be named inside PowerVS workspace
      file_name: string, full file name of the image inside COS bucket
      storage_tier: string, storage tier which the image will be stored in after import. Supported values are: "tier0", "tier1", "tier3", "tier5k".
      sap_type: optional string, "Hana", "Netweaver", don't use it for non-SAP image.
  EOF
  type = object({
    image_name   = string
    file_name    = string
    storage_tier = string
    sap_type     = optional(string)
  })
  default = null
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
}

variable "powervs_custom_image_cos_service_credentials" {
  description = "Service credentials for the Cloud Object Storage bucket containing the custom PowerVS images. The bucket must have HMAC credentials enabled. Click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials) for a json example of a service credential."
  type        = string
  sensitive   = true
  default     = null
}

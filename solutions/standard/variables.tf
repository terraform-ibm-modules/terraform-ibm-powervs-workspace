################################
# Resource group module variable
################################

variable "existing_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision resources in to. If not set a new resource group will be created using the prefix variable"
  default     = null
}
variable "existing_resource_group_id" {
  type        = string
  description = "The ID of an existing resource group to provision resources in to. If not set a new resource group  will be created using the prefix variable"
  default     = null
}
variable "create_new_resource_group_name" {
  description = "Name of the new resource group to create if no existing name or ID is provided"
  type        = string
  default     = null

  validation {
    condition     = !(var.existing_resource_group_name != null) || var.create_new_resource_group_name != null
    error_message = "If both 'powervs_resource_group_name' and 'powervs_resource_group_id' are null, you must provide 'create_new_resource_group_name' to create a new resource group."
  }
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
    name = "sub_1",
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
    name = ""
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
    name = ""
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
  default     = []
}

variable "create_transit_gateway" {
  description = "Set to true to create a Transit Gateway for the PowerVS workspace and attach it."
  type        = bool
  default     = true
}

variable "existing_transit_gateway_id" {
  description = "Optional: ID of an existing Transit Gateway to use instead of creating a new one"
  type        = string
  default     = null
  validation {
    condition     = !(var.create_transit_gateway && var.existing_transit_gateway_id != null)
    error_message = "You cannot set both 'create_transit_gateway = true' and provide 'existing_transit_gateway_id'. Choose only one."
  }
}


variable "powervs_custom_images" {
  description = "Optionally import up to three custom images from Cloud Object Storage into PowerVS workspace. Requires 'powervs_custom_image_cos_configuration' to be set. image_name: string, must be unique. Name of image inside PowerVS workspace. file_name: string, object key of image inside COS bucket. storage_tier: string, storage tier which image will be stored in after import. Supported values: tier0, tier1, tier3, tier5k. sap_type: optional string, Supported values: null, Hana, Netweaver, use null for non-SAP image."
  type = object({
    powervs_custom_image1 = object({
      image_name   = string
      file_name    = string
      storage_tier = string
      sap_type     = optional(string)
    }),
    powervs_custom_image2 = object({
      image_name   = string
      file_name    = string
      storage_tier = string
      sap_type     = optional(string)
    }),
    powervs_custom_image3 = object({
      image_name   = string
      file_name    = string
      storage_tier = string
      sap_type     = optional(string)
    })
  })
  default = {
    "powervs_custom_image1" : {
      "image_name" : "",
      "file_name" : "",
      "storage_tier" : "",
      "sap_type" : null
    },
    "powervs_custom_image2" : {
      "image_name" : "",
      "file_name" : "",
      "storage_tier" : "",
      "sap_type" : null
    },
    "powervs_custom_image3" : {
      "image_name" : "",
      "file_name" : "",
      "storage_tier" : "",
      "sap_type" : null
    }
  }
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
  default = {
    "bucket_name" : "",
    "bucket_access" : "",
    "bucket_region" : ""
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

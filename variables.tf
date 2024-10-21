########################################################
# Mandatory variables
########################################################

variable "pi_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
  validation {
    condition     = contains(["syd04", "syd05", "eu-de-1", "eu-de-2", "lon04", "lon06", "us-east", "wdc06", "wdc07", "us-south", "dal10", "dal12", "tok04", "osa21", "sao01", "sao04", "mon01", "tor01", "mad02", "mad04"], var.pi_zone)
    error_message = "Only Following DC values are supported : syd04, syd05, eu-de-1, eu-de-2, lon04, lon06, us-east, wdc06, wdc07, us-south, dal10, dal12, tok04, osa21, sao01, sao04 mon01, tor01, mad02, mad04"
  }
}

variable "pi_resource_group_name" {
  description = "Existing Resource Group Name."
  type        = string
}

variable "pi_workspace_name" {
  description = "Name of IBM Cloud PowerVS workspace which will be created."
  type        = string
}

variable "pi_ssh_public_key" {
  description = "Name and value of the Public SSH key to create in PowerVS workspace."
  type = object({
    name  = string
    value = string
  })
}

variable "pi_image_names" {
  description = "List of images to be imported into cloud account from catalog images. Supported values can be found [here](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-workspace/blob/main/docs/catalog_images_list.md)"
  type        = list(string)
}

########################################################
#Optional Parameters
########################################################

variable "pi_transit_gateway_connection" {
  description = "Set enable to true and provide ID of the existing transit gateway to attach the CCs( Non PER DC) to TGW or to attach PowerVS workspace to TGW (PER DC). If enable is false, CCs will not be attached to TGW , or PowerVS workspace will not be attached to TGW, but CCs in (Non PER DC) will be created."
  type = object({
    enable             = bool
    transit_gateway_id = string
  })

  default = {
    enable             = false
    transit_gateway_id = ""
  }
}

variable "pi_private_subnet_1" {
  description = "IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })

  default = null

  validation {
    condition     = var.pi_private_subnet_1 != null ? anytrue([can(regex("^10\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.){2}(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_1.cidr)), can(regex("^192\\.168\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.)(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_1.cidr)), can(regex("^172\\.(([1][6-9])|([2][0-9])|([3][0-1]))\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.)(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_1.cidr))]) : true
    error_message = "Must be a valid private IPv4 CIDR block address."
  }
}

variable "pi_private_subnet_2" {
  description = "IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })

  default = null

  validation {
    condition     = var.pi_private_subnet_2 != null ? anytrue([can(regex("^10\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.){2}(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_2.cidr)), can(regex("^192\\.168\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.)(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_2.cidr)), can(regex("^172\\.(([1][6-9])|([2][0-9])|([3][0-1]))\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.)(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_2.cidr))]) : true
    error_message = "Must be a valid private IPv4 CIDR block address."
  }
}

variable "pi_private_subnet_3" {
  description = "IBM Cloud PowerVS third private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })

  default = null

  validation {
    condition     = var.pi_private_subnet_3 != null ? anytrue([can(regex("^10\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.){2}(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_3.cidr)), can(regex("^192\\.168\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.)(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_3.cidr)), can(regex("^172\\.(([1][6-9])|([2][0-9])|([3][0-1]))\\.((([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))\\.)(([2][0-5]{2})|([0-1]{0,1}[0-9]{1,2}))", var.pi_private_subnet_3.cidr))]) : true
    error_message = "Must be a valid private IPv4 CIDR block address."
  }
}

variable "pi_public_subnet_enable" {
  description = "IBM Cloud PowerVS Public Network. Set to true to enable this."
  type        = bool
  default     = false
}

variable "pi_tags" {
  description = "List of Tag names for IBM Cloud PowerVS workspace. Can be set to null."
  type        = list(string)
  default     = null
}

variable "pi_custom_image1" {
  description = <<EOF
    Optional custom image to import from Cloud Object Storage into PowerVS workspace.
      image_name: string, must be unique image name how the image will be named inside PowerVS workspace
      file_name: string, full file name of the image inside COS bucket
      storage_tier: string, storage tier which the image will be stored in after import. Must be one of the storage tiers supported in the PowerVS workspace region. Available tiers can be found using `ibmcloud pi storage-tiers`. Supported values are: "tier0", "tier1", "tier3", "tier5k"
      sap_type: string, "Hana", "Netweaver". Set to null if it's not an SAP image.
  EOF
  type = object({
    image_name   = string
    file_name    = string
    storage_tier = string
    sap_type     = string
  })
  validation {
    condition     = var.pi_custom_image1 != null ? var.pi_custom_image1.sap_type == null ? true : contains(["Hana", "Netweaver"], var.pi_custom_image1.sap_type) : true
    error_message = "Unsupported sap_type in pi_custom_image1. Supported values: null, \"Hana\", \"Netweaver\"."
  }
  validation {
    condition     = var.pi_custom_image1 != null ? contains(["tier0", "tier1", "tier3", "tier5k"], var.pi_custom_image1.storage_tier) : true
    error_message = "Invalid storage tier detected in pi_custom_image1. Supported values are: tier0, tier1, tier3, tier5k."
  }
  default = null
}

variable "pi_custom_image2" {
  description = <<EOF
    Optional custom image to import from Cloud Object Storage into PowerVS workspace.
      image_name: string, must be unique image name how the image will be named inside PowerVS workspace
      file_name: string, full file name of the image inside COS bucket
      storage_tier: string, storage tier which the image will be stored in after import. Must be one of the storage tiers supported in the PowerVS workspace region. Available tiers can be found using `ibmcloud pi storage-tiers`. Supported values are: "tier0", "tier1", "tier3", "tier5k"
      sap_type: string, "Hana", "Netweaver". Set to null if it's not an SAP image.
  EOF
  type = object({
    image_name   = string
    file_name    = string
    storage_tier = string
    sap_type     = string
  })
  validation {
    condition     = var.pi_custom_image2 != null ? var.pi_custom_image2.sap_type == null ? true : contains(["Hana", "Netweaver"], var.pi_custom_image2.sap_type) : true
    error_message = "Unsupported sap_type in pi_custom_image2. Supported values: null, \"Hana\", \"Netweaver\"."
  }
  validation {
    condition     = var.pi_custom_image2 != null ? contains(["tier0", "tier1", "tier3", "tier5k"], var.pi_custom_image2.storage_tier) : true
    error_message = "Invalid storage tier detected in pi_custom_image2. Supported values are: tier0, tier1, tier3, tier5k."
  }
  default = null
}

variable "pi_custom_image3" {
  description = <<EOF
    Optional custom image to import from Cloud Object Storage into PowerVS workspace.
      image_name: string, must be unique image name how the image will be named inside PowerVS workspace
      file_name: string, full file name of the image inside COS bucket
      storage_tier: string, storage tier which the image will be stored in after import. Must be one of the storage tiers supported in the PowerVS workspace region. Available tiers can be found using `ibmcloud pi storage-tiers`. Supported values are: "tier0", "tier1", "tier3", "tier5k"
      sap_type: string, "Hana", "Netweaver". Set to null if it's not an SAP image.
  EOF
  type = object({
    image_name   = string
    file_name    = string
    storage_tier = string
    sap_type     = string
  })
  validation {
    condition     = var.pi_custom_image3 != null ? var.pi_custom_image3.sap_type == null ? true : contains(["Hana", "Netweaver"], var.pi_custom_image3.sap_type) : true
    error_message = "Unsupported sap_type in pi_custom_image3. Supported values: null, \"Hana\", \"Netweaver\"."
  }
  validation {
    condition     = var.pi_custom_image3 != null ? contains(["tier0", "tier1", "tier3", "tier5k"], var.pi_custom_image3.storage_tier) : true
    error_message = "Invalid storage tier detected in pi_custom_image3. Supported values are: tier0, tier1, tier3, tier5k."
  }
  default = null
}

variable "pi_custom_image_cos_configuration" {
  description = <<EOF
    Cloud Object Storage bucket containing the custom PowerVS images. Images will be imported into the PowerVS Workspace.
      bucket_name: string, name of the COS bucket
      bucket_access: string, possible values: "public", "private" (private requires pi_custom_image_cos_service_credentials)
      bucket_region: string, COS bucket region
  EOF
  type = object({
    bucket_name   = string
    bucket_access = string
    bucket_region = string
  })
  default = null
  validation {
    condition     = var.pi_custom_image_cos_configuration != null ? contains(["public", "private"], var.pi_custom_image_cos_configuration.bucket_access) : true
    error_message = "Invalid pi_custom_image_cos_configuration.bucket_access. Allowed values: [\"public\", \"private\"]."
  }
  validation {
    condition     = alltrue([var.pi_custom_image1 == null, var.pi_custom_image2 == null, var.pi_custom_image3 == null]) ? true : var.pi_custom_image_cos_configuration != null
    error_message = "The import of custom images into PowerVS workspace requires a cos configuration. pi_custom_image_cos_configuration undefined."
  }
}

variable "pi_custom_image_cos_service_credentials" {
  description = "Service credentials for the Cloud Object Storage bucket containing the custom PowerVS images. The bucket must have HMAC credentials enabled. Click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials) for a json example of a service credential."
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.pi_custom_image_cos_configuration != null ? var.pi_custom_image_cos_configuration.bucket_access == "private" ? var.pi_custom_image_cos_service_credentials != null : true : true
    error_message = "pi_custom_image_cos_service_credentials are required to access private COS buckets."
  }
}

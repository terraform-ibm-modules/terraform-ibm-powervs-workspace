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

variable "powervs_image_names" {
  description = "List of Images to be imported into cloud account from catalog images."
  type        = list(string)
  default     = ["SLES15-SP5-SAP", "RHEL9-SP2-SAP"]
}

variable "powervs_private_subnet_1" {
  description = "IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })
  default = {
    name = "sub_1"
    cidr = "10.51.0.0/24"
  }
}

variable "powervs_private_subnet_2" {
  description = "IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
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

variable "custom_pi_images" {
  description = <<EOF
    Optional list of custom images to import from Cloud Object Storage into PowerVS workspace.
      image_name: string, must be unique image name how the image will be named inside PowerVS workspace
      file_name: string, full file name of the image inside COS bucket
      storage_tier: string, storage tier which the image will be stored in after import. Must be one of the storage tiers supported in the PowerVS workspace region. Available tiers can be found using `ibmcloud pi storage-tiers`. Typical values are: "tier0", "tier1", "tier3", "tier5k"
      sap_type: string, "Hana", "Netweaver". Set to null if it's not an SAP image.
  EOF
  type = list(object({
    image_name   = string
    file_name    = string
    storage_tier = string
    sap_type     = string
  }))
  validation {
    condition     = length([for image in var.custom_pi_images : image.image_name]) == length(distinct([for image in var.custom_pi_images : image.image_name]))
    error_message = "Duplicate image_name detected. All image names must be unique in their workspace."
  }
  validation {
    condition     = alltrue([for image in var.custom_pi_images : image.sap_type == null ? true : contains(["Hana", "Netweaver"], image.sap_type)])
    error_message = "Unsupported sap_type. Supported values: null, \"Hana\", \"Netweaver\"."
  }
  default = []
}

variable "custom_pi_image_cos_configuration" {
  description = <<EOF
    Cloud Object Storage bucket containing the custom PowerVS images. Images will be imported into the PowerVS Workspace.
      bucket_name: string, name of the COS bucket
      bucket_access: string, possible values: "public", "private" (private requires custom_pi_image_cos_service_credentials)
      bucket_region: string, COS bucket region
  EOF
  type = object({
    bucket_name   = string
    bucket_access = string
    bucket_region = string
  })
  default = {
    "bucket_name" : "image-bucket-name",
    "bucket_access" : "public"
    "bucket_region" : "eu-geo",
  }
  validation {
    condition     = contains(["public", "private"], var.custom_pi_image_cos_configuration.bucket_access)
    error_message = "Invalid custom_pi_image_cos_configuration.bucket_access. Allowed values: [\"public\", \"private\"]."
  }
}

variable "custom_pi_image_cos_service_credentials" {
  description = "Service credentials for the Cloud Object Storage bucket containing the custom PowerVS images. The bucket must have HMAC credentials enabled. Click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials) for a json example of a service credential."
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.custom_pi_image_cos_configuration.bucket_access == "private" ? var.custom_pi_image_cos_service_credentials != null : true
    error_message = "custom_pi_image_cos_service_credentials are required to access private COS buckets."
  }
}

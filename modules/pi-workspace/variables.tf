variable "pi_zone" {
  description = "IBM Cloud PowerVS Zone."
  type        = string
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
  description = "Name and value of the Public SSH key to create."
  type = object({
    name  = string
    value = string
  })
}

variable "pi_private_subnet_1" {
  description = "IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })
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

#####################################################
# Optional Parameters
#####################################################

variable "pi_tags" {
  description = "List of Tag names for IBM Cloud PowerVS workspace."
  type        = list(string)
}

variable "pi_image_names" {
  description = "List of images to be imported into cloud account from catalog images. Max number of images that can be imported is 6 images. Can be set to null and images will not be imported. Supported values can be found [here](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-workspace/blob/main/docs/catalog_images_list.md)"
  type        = list(string)
  validation {
    error_message = "Exceeds the length of list of list by 6. Can support max 6 values only."
    condition     = var.pi_image_names != null ? length(var.pi_image_names) < 7 ? true : false : true
  }
}

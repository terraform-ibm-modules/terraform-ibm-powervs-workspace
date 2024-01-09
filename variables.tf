variable "pi_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
  validation {
    condition     = contains(["syd04", "syd05", "eu-de-1", "eu-de-2", "lon04", "lon06", "us-east", "wdc06", "wdc07", "us-south", "dal10", "dal12", "tok04", "osa21", "sao01", "sao04", "mon01", "tor01", "mad02", "mad04"], var.pi_zone)
    error_message = "Only Following DC values are supported : syd04, syd05, eu-de-1, eu-de-2, lon04, lon06, us-east, wdc06, us-south, dal10, dal12, tok04, osa21, sao01, sao04 mon01, tor01, mad02, mad04"
  }
}

variable "pi_resource_group_name" {
  description = "Existing Resource Group Name."
  type        = string
}

########################################################
# Workspace variables
########################################################

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

variable "pi_image_names" {
  description = "List of images to be imported into cloud account from catalog images. Supported values can be found [here](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-workspace/blob/main/docs/catalog_images_list.md)"
  type        = list(string)
}

########################################################
#Optional Parameters
########################################################

variable "pi_private_subnet_1" {
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

variable "pi_private_subnet_2" {
  description = "IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })
  default = null
}

variable "pi_private_subnet_3" {
  description = "IBM Cloud PowerVS third private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })
  default = null
}

variable "pi_public_subnet_enable" {
  description = "IBM Cloud PowerVS Public Network. Set to true to enable this."
  type        = bool
  default     = false
}

variable "pi_cloud_connection" {
  description = "Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global_routing (true or false), metered (true or false). Not applicable for PER enabled DC and CCs will not be created."
  type = object({
    count          = number
    speed          = number
    global_routing = bool
    metered        = bool
  })

  default = {
    count          = 2
    speed          = 5000
    global_routing = true
    metered        = true
  }
}

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

variable "pi_tags" {
  description = "List of Tag names for IBM Cloud PowerVS workspace. Can be set to null."
  type        = list(string)
  default     = null
}

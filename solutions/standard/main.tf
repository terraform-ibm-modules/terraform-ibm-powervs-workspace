#############################
# Resource group
#############################

locals {
  powervs_rg_create_name = var.existing_resource_group_name == null ? (var.create_new_resource_group_name != null ? var.create_new_resource_group_name : "${var.prefix}-resource-group") : null
  # Input resource group name used for creating or referencing the RG. If an existing RG was supplied,
  # use that, otherwise use the name that will be created.
  powervs_resource_group_input = var.existing_resource_group_name != null ? var.existing_resource_group_name : var.existing_resource_group_id != null ? null : local.powervs_rg_create_name
}

resource "ibm_resource_group" "resource_group" {
  count = var.existing_resource_group_name == null ? 1 : 0
  name  = local.powervs_rg_create_name
}
data "ibm_resource_group" "existing" {
  count = var.existing_resource_group_name != null ? 1 : 0
  name  = var.existing_resource_group_name
}

locals {
  powervs_resource_group_id = (
  var.existing_resource_group_id != null ? var.existing_resource_group_id : var.existing_resource_group_name != null ? data.ibm_resource_group.existing[0].id : ibm_resource_group.resource_group[0].id)
}

#############################
# Create Transit gateway
#############################
resource "ibm_tg_gateway" "transit_gateway" {
  provider       = ibm.ibm-is
  count          = var.create_transit_gateway && var.existing_transit_gateway_id == null ? 1 : 0
  name           = "${var.prefix}-transit-gateway-1"
  location       = lookup(local.ibm_powervs_zone_cloud_region_map, var.powervs_zone, null)
  global         = false
  resource_group = local.powervs_resource_group_id
}

#############################
# Create PowerVS Workspace
#############################
locals {
  # powervs_transit_gateway_connection = { enable = var.create_transit_gateway ? true : false, transit_gateway_id = var.create_transit_gateway ? ibm_tg_gateway.transit_gateway[0].id : "" }
  powervs_transit_gateway_connection = {
    enable             = var.create_transit_gateway || var.existing_transit_gateway_id != null
    transit_gateway_id = var.create_transit_gateway ? ibm_tg_gateway.transit_gateway[0].id : var.existing_transit_gateway_id
  }

  powervs_workspace_name      = "${var.prefix}-${var.powervs_workspace_name}"
  powervs_ssh_public_key      = { name = "${var.prefix}-pi-ssh-key", value = var.powervs_ssh_public_key }
  powervs_resource_group_name = local.powervs_resource_group_input
}


locals {
  powervs_private_subnet_1 = merge(
    var.powervs_private_subnet_1,
    {
      name = "${var.prefix}-${var.powervs_private_subnet_1.name}"
    }
  )

  powervs_private_subnet_2 = (var.powervs_private_subnet_2 == null ||
    (trimspace(var.powervs_private_subnet_2.name) == "" && trimspace(var.powervs_private_subnet_2.cidr) == "") ? null : merge(
      var.powervs_private_subnet_2,
      {
        name = "${var.prefix}-${var.powervs_private_subnet_2.name}"
      }
  ))

  powervs_private_subnet_3 = (
    var.powervs_private_subnet_3 == null ||
    (trimspace(var.powervs_private_subnet_3.name) == "" && trimspace(var.powervs_private_subnet_3.cidr) == "")
    ) ? null : merge(
    var.powervs_private_subnet_3,
    {
      name = "${var.prefix}-${var.powervs_private_subnet_3.name}"
    }
  )
}
locals {
  powervs_custom_image1 = (
    var.powervs_custom_images.powervs_custom_image1.image_name == "" &&
    var.powervs_custom_images.powervs_custom_image1.file_name == "" &&
    var.powervs_custom_images.powervs_custom_image1.storage_tier == ""
  ) ? null : var.powervs_custom_images.powervs_custom_image1
  powervs_custom_image2 = (
    var.powervs_custom_images.powervs_custom_image2.image_name == "" &&
    var.powervs_custom_images.powervs_custom_image2.file_name == "" &&
    var.powervs_custom_images.powervs_custom_image2.storage_tier == ""
  ) ? null : var.powervs_custom_images.powervs_custom_image2
  powervs_custom_image3 = (
    var.powervs_custom_images.powervs_custom_image3.image_name == "" &&
    var.powervs_custom_images.powervs_custom_image3.file_name == "" &&
    var.powervs_custom_images.powervs_custom_image3.storage_tier == ""
  ) ? null : var.powervs_custom_images.powervs_custom_image3
  powervs_custom_image_cos_configuration = (
    var.powervs_custom_image_cos_configuration.bucket_name == "" &&
    var.powervs_custom_image_cos_configuration.bucket_access == "" &&
    var.powervs_custom_image_cos_configuration.bucket_region == ""
  ) ? null : var.powervs_custom_image_cos_configuration
}
##############################
# PowerVS Workspace module
##############################
module "powervs_workspace" {
  source     = "../../"
  depends_on = [ibm_resource_group.resource_group]

  pi_zone                                 = var.powervs_zone
  pi_resource_group_name                  = local.powervs_resource_group_name
  pi_resource_group_id                    = local.powervs_resource_group_id
  pi_workspace_name                       = local.powervs_workspace_name
  pi_tags                                 = var.powervs_tags
  pi_ssh_public_key                       = local.powervs_ssh_public_key
  pi_private_subnet_1                     = local.powervs_private_subnet_1 != null ? local.powervs_private_subnet_1 : null
  pi_private_subnet_2                     = local.powervs_private_subnet_2 != null ? local.powervs_private_subnet_2 : null
  pi_private_subnet_3                     = local.powervs_private_subnet_3 != null ? local.powervs_private_subnet_3 : null
  pi_public_subnet_enable                 = var.powervs_public_network_enable
  pi_transit_gateway_connection           = local.powervs_transit_gateway_connection
  pi_custom_image1                        = local.powervs_custom_image1
  pi_custom_image2                        = local.powervs_custom_image2
  pi_custom_image3                        = local.powervs_custom_image3
  pi_custom_image_cos_service_credentials = var.powervs_custom_image_cos_service_credentials
  pi_custom_image_cos_configuration       = local.powervs_custom_image_cos_configuration
}

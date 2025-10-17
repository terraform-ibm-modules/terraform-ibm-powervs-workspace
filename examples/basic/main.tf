#############################
# Resource group
#############################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.powervs_resource_group_name == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.powervs_resource_group_name
}

#############################
# Create Transit gateway
#############################

resource "ibm_tg_gateway" "transit_gateway" {
  provider = ibm.ibm-is
  count    = var.create_transit_gateway ? 1 : 0

  name           = "${var.prefix}-transit-gateway-1"
  location       = lookup(local.ibm_powervs_zone_cloud_region_map, var.powervs_zone, null)
  global         = false
  resource_group = module.resource_group.resource_group_id
}


#############################
# Create PowerVS Workspace
#############################
locals {
  powervs_transit_gateway_connection = { enable = var.create_transit_gateway ? true : false, transit_gateway_id = var.create_transit_gateway ? ibm_tg_gateway.transit_gateway[0].id : "" }
  powervs_workspace_name             = "${var.prefix}-${var.powervs_workspace_name}"
  powervs_ssh_public_key             = { name = "${var.prefix}-pi-ssh-key", value = var.powervs_ssh_public_key }
  powervs_resource_group_name        = module.resource_group.resource_group_name
}

module "powervs_workspace" {
  source     = "../../"
  depends_on = [module.resource_group]

  pi_zone                                 = var.powervs_zone
  pi_resource_group_name                  = local.powervs_resource_group_name
  pi_workspace_name                       = local.powervs_workspace_name
  pi_tags                                 = var.powervs_tags
  pi_ssh_public_key                       = local.powervs_ssh_public_key
  pi_private_subnet_1                     = var.powervs_private_subnet_1
  pi_private_subnet_2                     = var.powervs_private_subnet_2
  pi_public_subnet_enable                 = var.powervs_public_network_enable
  pi_transit_gateway_connection           = local.powervs_transit_gateway_connection
  pi_custom_image1                        = var.powervs_custom_image1
  pi_custom_image_cos_configuration       = var.powervs_custom_image_cos_configuration
  pi_custom_image_cos_service_credentials = var.powervs_custom_image_cos_service_credentials
}

#############################
# Resource group
#############################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.powervs_resource_group_name == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.powervs_resource_group_name
}

#############################
# Create Transit gateway
#############################

resource "ibm_tg_gateway" "transit_gateway" {
  provider = ibm.ibm-is

  name           = "${var.prefix}-transit-gateway-1"
  location       = lookup(local.ibm_powervs_zone_cloud_region_map, var.powervs_zone, null)
  global         = false
  resource_group = module.resource_group.resource_group_id
}


#############################
# Create PowerVS Workspace
#############################

module "powervs_infra" {
  source     = "../../"
  depends_on = [module.resource_group]

  pi_zone                       = var.powervs_zone
  pi_resource_group_name        = module.resource_group.resource_group_name
  pi_workspace_name             = "${var.prefix}-${var.powervs_workspace_name}"
  pi_tags                       = var.powervs_tags
  pi_image_names                = var.powervs_image_names
  pi_ssh_public_key             = var.powervs_ssh_public_key
  pi_private_subnet_1           = var.powervs_private_subnet_1
  pi_private_subnet_2           = var.powervs_private_subnet_2
  pi_public_subnet_enable       = var.powervs_public_network_enable
  pi_transit_gateway_connection = { enable = true, transit_gateway_id = ibm_tg_gateway.transit_gateway.id }
  pi_cloud_connection           = var.powervs_cloud_connection
}

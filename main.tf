#####################################################
# IBM Cloud PowerVS Configuration
#####################################################

locals {
  pi_per_enabled_dc_list = ["dal10"]
  pi_per_enabled         = contains(local.pi_per_enabled_dc_list, var.pi_zone)
}

#####################################################
# Workspace Submodule ( Creates Workspace, SSH key,
# Subnets, Imports catalog images )
#####################################################

module "powervs_workspace" {
  source = "./submodules/pi-workspace"

  pi_zone                 = var.pi_zone
  pi_resource_group_name  = var.pi_resource_group_name
  pi_workspace_name       = var.pi_workspace_name
  pi_tags                 = var.pi_tags
  pi_image_names          = var.pi_image_names
  pi_ssh_public_key       = var.pi_ssh_public_key
  pi_private_subnet_1     = var.pi_private_subnet_1
  pi_private_subnet_2     = var.pi_private_subnet_2
  pi_private_subnet_3     = var.pi_private_subnet_3
  pi_public_subnet_enable = var.pi_public_subnet_enable
}


#####################################################
# CC Create Submodule
# Non PER DC: Creates CCs, attaches CCs to TGW
# PER DC: Skip
#####################################################

module "powervs_cloud_connection_create" {
  source = "./submodules/pi-cloudconnection-create"
  count  = local.pi_per_enabled ? 0 : 1

  pi_zone             = var.pi_zone
  pi_workspace_guid   = module.powervs_workspace.pi_workspace_guid
  transit_gateway_id  = var.transit_gateway_id
  pi_cloud_connection = var.pi_cloud_connection
}

#####################################################
# CC Subnet Attach Submodule
# Non PER DC: Attaches Subnets to CCs
# PER DC: Skip
#####################################################

locals {
  pi_private_subnets    = [module.powervs_workspace.pi_private_subnet_1, module.powervs_workspace.pi_private_subnet_2, module.powervs_workspace.pi_private_subnet_3]
  pi_private_subnet_ids = [for subnet in local.pi_private_subnets : subnet.id if subnet != null]
}

module "powervs_cloud_connection_attach" {
  source     = "./submodules/pi-cloudconnection-attach"
  depends_on = [module.powervs_cloud_connection_create]
  count      = local.pi_per_enabled ? 0 : 1

  pi_workspace_guid         = module.powervs_workspace.pi_workspace_guid
  pi_cloud_connection_count = var.pi_cloud_connection.count
  pi_private_subnet_ids     = local.pi_private_subnet_ids
}


#####################################################
# Attach PowerVS Workspace to transit gateway
# Non PER DC: Skip
# PER DC: Attach
#####################################################

resource "ibm_tg_connection" "tg_powervs_workspace_attach" {
  count = local.pi_per_enabled && var.transit_gateway_id != null ? 1 : 0

  name         = var.pi_workspace_name
  network_type = "power_virtual_server"
  gateway      = var.transit_gateway_id
  network_id   = module.powervs_workspace.pi_workspace_id
}

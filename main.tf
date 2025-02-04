#####################################################
# IBM Cloud PowerVS Workspace Module
#####################################################

#####################################################
# Create PowerVS workspace
#####################################################

locals {
  service_type     = "power-iaas"
  plan             = "power-virtual-server-private-group"
  ibmcloud_api_key = var.ibmcloud_api_key
  zone             = "satloc_dal_clp25g92006uiuvbvku0"
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  zone             = "satloc_dal_clp25g92006uiuvbvku0"
}

# How to pass the customer satellite locations/zones?
# Handle the occurrences of duplicates in the pi image list

data "ibm_resource_group" "resource_group_ds" {
  name = var.pi_resource_group_name
}

resource "ibm_resource_instance" "pi_workspace" {
  name              = var.pi_workspace_name
  service           = local.service_type
  plan              = local.plan
  location          = var.pi_zone
  resource_group_id = data.ibm_resource_group.resource_group_ds.id
  tags              = (var.pi_tags != null ? var.pi_tags : [])

  timeouts {
    create = "6m"
    update = "5m"
    delete = "10m"
  }
}


#####################################################
# Create SSH Public Key in PowerVS workspace
#####################################################

resource "ibm_pi_key" "ssh_key" {
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_key_name          = var.pi_ssh_public_key.name
  pi_ssh_key           = var.pi_ssh_public_key.value
}


#####################################################
# Attach PowerVS Workspace to transit gateway
#####################################################

resource "ibm_tg_connection" "tg_powervs_workspace_attach" {
  count        = var.pi_transit_gateway_connection != null ? var.pi_transit_gateway_connection.enable ? 1 : 0 : 0
  name         = var.pi_workspace_name
  network_type = "power_virtual_server"
  gateway      = var.pi_transit_gateway_connection.transit_gateway_id
  network_id   = ibm_resource_instance.pi_workspace.id
}

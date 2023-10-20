#################################################
# Attach PowerVS Subnets to CCs
#################################################

data "ibm_pi_cloud_connections" "cloud_connection_ds" {
  pi_cloud_instance_id = var.pi_workspace_guid
}

################################################################
# Attach 1 or 2 or 3 private subnets to First Cloud Connection
################################################################

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_1" {
  count = var.pi_cloud_connection_count > 0 && length(var.pi_private_subnet_ids) > 0 ? 1 : 0

  pi_cloud_instance_id   = var.pi_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.pi_private_subnet_ids[0]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_2" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_1]
  count      = var.pi_cloud_connection_count > 0 && length(var.pi_private_subnet_ids) > 1 ? 1 : 0

  pi_cloud_instance_id   = var.pi_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.pi_private_subnet_ids[1]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_3" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_1, ibm_pi_cloud_connection_network_attach.private_subnet_2]
  count      = var.pi_cloud_connection_count > 0 && length(var.pi_private_subnet_ids) > 2 ? 1 : 0

  pi_cloud_instance_id   = var.pi_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.pi_private_subnet_ids[2]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

#################################################################
# Attach 1 or 2 or 3 private subnets to Second Cloud Connection
#################################################################

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_1_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_1, ibm_pi_cloud_connection_network_attach.private_subnet_2, ibm_pi_cloud_connection_network_attach.private_subnet_3]
  count      = var.pi_cloud_connection_count > 1 && length(var.pi_private_subnet_ids) > 0 ? 1 : 0

  pi_cloud_instance_id   = var.pi_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.pi_private_subnet_ids[0]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}


resource "ibm_pi_cloud_connection_network_attach" "private_subnet_2_redundant" {
  count                  = var.pi_cloud_connection_count > 1 && length(var.pi_private_subnet_ids) > 1 ? 1 : 0
  depends_on             = [ibm_pi_cloud_connection_network_attach.private_subnet_1, ibm_pi_cloud_connection_network_attach.private_subnet_2, ibm_pi_cloud_connection_network_attach.private_subnet_3, ibm_pi_cloud_connection_network_attach.private_subnet_1_redundant]
  pi_cloud_instance_id   = var.pi_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.pi_private_subnet_ids[1]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_3_redundant" {
  count      = var.pi_cloud_connection_count > 1 && length(var.pi_private_subnet_ids) > 2 ? 1 : 0
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_1, ibm_pi_cloud_connection_network_attach.private_subnet_2, ibm_pi_cloud_connection_network_attach.private_subnet_3, ibm_pi_cloud_connection_network_attach.private_subnet_1_redundant, ibm_pi_cloud_connection_network_attach.private_subnet_2_redundant]

  pi_cloud_instance_id   = var.pi_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.pi_private_subnet_ids[2]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

#################################################################
# Moved blocks
#################################################################


moved {
  from = ibm_pi_cloud_connection_network_attach.powervs_subnet_mgmt_nw_attach[0]
  to   = ibm_pi_cloud_connection_network_attach.private_subnet_1[0]
}

moved {
  from = ibm_pi_cloud_connection_network_attach.powervs_subnet_bkp_nw_attach[0]
  to   = ibm_pi_cloud_connection_network_attach.private_subnet_2[0]
}

moved {
  from = ibm_pi_cloud_connection_network_attach.powervs_subnet_mgmt_nw_attach_backup[0]
  to   = ibm_pi_cloud_connection_network_attach.private_subnet_1_redundant[0]
}

moved {
  from = ibm_pi_cloud_connection_network_attach.powervs_subnet_bkp_nw_attach_backup[0]
  to   = ibm_pi_cloud_connection_network_attach.private_subnet_2_redundant[0]
}

########################################################
# IBM Cloud PowerVS Cloud Connection
########################################################

locals {
  cloud_connection_name_1 = "${var.pi_zone}-conn-1"
  cloud_connection_name_2 = "${var.pi_zone}-conn-2"
}

#####################################################
# Create Cloud Connections in Non PER DC
#####################################################

resource "ibm_pi_cloud_connection" "cloud_connection" {
  count = var.pi_cloud_connection.count > 0 ? 1 : 0

  pi_cloud_instance_id                = var.pi_workspace_guid
  pi_cloud_connection_name            = local.cloud_connection_name_1
  pi_cloud_connection_speed           = var.pi_cloud_connection.speed
  pi_cloud_connection_global_routing  = var.pi_cloud_connection.global_routing
  pi_cloud_connection_metered         = var.pi_cloud_connection.metered
  pi_cloud_connection_transit_enabled = true
}

resource "ibm_pi_cloud_connection" "cloud_connection_backup" {
  depends_on = [ibm_pi_cloud_connection.cloud_connection]
  count      = var.pi_cloud_connection.count > 1 ? 1 : 0

  pi_cloud_instance_id                = var.pi_workspace_guid
  pi_cloud_connection_name            = local.cloud_connection_name_2
  pi_cloud_connection_speed           = var.pi_cloud_connection.speed
  pi_cloud_connection_global_routing  = var.pi_cloud_connection.global_routing
  pi_cloud_connection_metered         = var.pi_cloud_connection.metered
  pi_cloud_connection_transit_enabled = true
}

######################################################
# Get direct link CRNs from created cloud connections
######################################################

data "ibm_dl_gateway" "gateway_ds_1" {
  depends_on = [ibm_pi_cloud_connection.cloud_connection]
  count      = var.pi_cloud_connection.count > 0 ? 1 : 0

  name = local.cloud_connection_name_1
}

data "ibm_dl_gateway" "gateway_ds_2" {
  count      = var.pi_cloud_connection.count > 1 ? 1 : 0
  depends_on = [ibm_pi_cloud_connection.cloud_connection_backup]

  name = local.cloud_connection_name_2
}

resource "time_sleep" "dl_1_resource_propagation" {
  depends_on = [data.ibm_dl_gateway.gateway_ds_1]
  count      = var.pi_cloud_connection.count > 0 ? 1 : 0

  create_duration = "120s"
  triggers = {
    dl_crn = data.ibm_dl_gateway.gateway_ds_1[0].crn
  }
}

resource "time_sleep" "dl_2_resource_propagation" {
  depends_on = [data.ibm_dl_gateway.gateway_ds_2]
  count      = var.pi_cloud_connection.count > 1 ? 1 : 0

  create_duration = "120s"
  triggers = {
    dl_crn = data.ibm_dl_gateway.gateway_ds_2[0].crn
  }
}

#####################################################
# Attach direct link CRNs to transit gateway : Non PER
#####################################################

resource "ibm_tg_connection" "ibm_tg_cc_connection_1" {
  depends_on = [ibm_pi_cloud_connection.cloud_connection_backup]
  count      = var.pi_cloud_connection.count > 0 && var.pi_transit_gateway_connection.enable ? 1 : 0

  name         = local.cloud_connection_name_1
  network_type = "directlink"
  gateway      = var.pi_transit_gateway_connection.transit_gateway_id
  network_id   = time_sleep.dl_1_resource_propagation[0].triggers["dl_crn"]
}

resource "ibm_tg_connection" "ibm_tg_cc_connection_2" {
  depends_on = [ibm_tg_connection.ibm_tg_cc_connection_1]
  count      = var.pi_cloud_connection.count > 1 && var.pi_transit_gateway_connection.enable ? 1 : 0

  name         = local.cloud_connection_name_2
  network_type = "directlink"
  gateway      = var.pi_transit_gateway_connection.transit_gateway_id
  network_id   = time_sleep.dl_2_resource_propagation[0].triggers["dl_crn"]
}

moved {
  from = ibm_tg_connection.ibm_tg_connection_1
  to   = ibm_tg_connection.ibm_tg_cc_connection_1
}

moved {
  from = ibm_tg_connection.ibm_tg_connection_2
  to   = ibm_tg_connection.ibm_tg_cc_connection_2
}

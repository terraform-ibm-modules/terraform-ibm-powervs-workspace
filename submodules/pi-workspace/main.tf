#####################################################
# This module creates
# 1. PowerVS workspace
# 2. Creates Ssh Key
# 3. Creates 3 private subnets (optional)
# 4. Creates 1 public network (optional)
# 5. Imports up to 6 catalog images
#####################################################

locals {
  service_type = "power-iaas"
  plan         = "power-virtual-server-group"
}

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

################################################
# #Moved blocks
################################################

moved {
  from = ibm_resource_instance.powervs_workspace
  to   = ibm_resource_instance.pi_workspace
}

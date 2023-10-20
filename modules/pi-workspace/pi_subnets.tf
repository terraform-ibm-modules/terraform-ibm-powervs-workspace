#####################################################
# Create Private Subnets
#####################################################

resource "ibm_pi_network" "private_subnet_1" {
  count                = var.pi_private_subnet_1 != null ? 1 : 0
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_network_name      = var.pi_private_subnet_1.name
  pi_cidr              = var.pi_private_subnet_1.cidr
  pi_dns               = ["127.0.0.1"]
  pi_network_type      = "vlan"
  pi_network_jumbo     = true
}

resource "ibm_pi_network" "private_subnet_2" {
  count = var.pi_private_subnet_1 != null ? 1 : 0

  depends_on           = [ibm_pi_network.private_subnet_1]
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_network_name      = var.pi_private_subnet_2.name
  pi_cidr              = var.pi_private_subnet_2.cidr
  pi_dns               = ["127.0.0.1"]
  pi_network_type      = "vlan"
  pi_network_jumbo     = true
}

resource "ibm_pi_network" "private_subnet_3" {
  count = var.pi_private_subnet_3 != null ? 1 : 0

  depends_on           = [ibm_pi_network.private_subnet_2]
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_network_name      = var.pi_private_subnet_3.name
  pi_cidr              = var.pi_private_subnet_3.cidr
  pi_dns               = ["127.0.0.1"]
  pi_network_type      = "vlan"
  pi_network_jumbo     = true
}


#####################################################
# Create Public Subnet
#####################################################

resource "ibm_pi_network" "public_subnet" {
  count                = var.pi_public_subnet_enable ? 1 : 0
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_network_name      = "public_net"

  pi_dns           = ["9.9.9.9"]
  pi_network_type  = "pub-vlan"
  pi_network_jumbo = true
}


################################################
# Moved blocks
################################################

moved {
  from = ibm_pi_network.management_network
  to   = ibm_pi_network.private_subnet_1[0]
}

moved {
  from = ibm_pi_network.backup_network
  to   = ibm_pi_network.private_subnet_2[0]
}

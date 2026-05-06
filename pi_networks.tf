#####################################################
# Create Private Subnets
#####################################################

# Adding sleep because of PER enabled workspace
# which needs some time to initialize
resource "time_sleep" "wait_30_sec" {
  depends_on      = [ibm_resource_instance.pi_workspace]
  create_duration = "30s"
}

resource "ibm_pi_network" "private_subnet_1" {
  depends_on = [time_sleep.wait_30_sec]
  count      = var.pi_private_subnet_1 != null ? 1 : 0

  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_network_name      = var.pi_private_subnet_1.name
  pi_cidr              = var.pi_private_subnet_1.cidr
  pi_network_type      = "vlan"
  pi_advertise         = var.pi_private_subnet_1.advertise
  pi_arp_broadcast     = var.pi_private_subnet_1.arp_broadcast
  pi_dns               = var.pi_private_subnet_1.dns
  pi_network_mtu       = 9000
  pi_user_tags         = var.pi_tags != null ? var.pi_tags : []
  pi_ipaddress_range {
    // Try to retrieve the value from the variable, if it fails, use the whole address range inferred from the CIDR
    pi_starting_ip_address = try(var.pi_private_subnet_1.ip_address_range.starting_ip_address, cidrhost(var.pi_private_subnet_1.cidr, 2))
    pi_ending_ip_address   = try(var.pi_private_subnet_1.ip_address_range.ending_ip_address, cidrhost(var.pi_private_subnet_1.cidr, pow(2, (32 - tonumber(split("/", var.pi_private_subnet_1.cidr)[1]))) - 2))
  }
}


resource "ibm_pi_network" "private_subnet_2" {
  count = var.pi_private_subnet_2 != null ? 1 : 0

  depends_on           = [ibm_pi_network.private_subnet_1]
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_network_name      = var.pi_private_subnet_2.name
  pi_cidr              = var.pi_private_subnet_2.cidr
  pi_network_type      = "vlan"
  pi_advertise         = var.pi_private_subnet_2.advertise
  pi_arp_broadcast     = var.pi_private_subnet_2.arp_broadcast
  pi_dns               = var.pi_private_subnet_2.dns
  pi_network_mtu       = 9000
  pi_user_tags         = var.pi_tags != null ? var.pi_tags : []
  pi_ipaddress_range {
    pi_starting_ip_address = try(var.pi_private_subnet_2.ip_address_range.starting_ip_address, cidrhost(var.pi_private_subnet_2.cidr, 2))
    pi_ending_ip_address   = try(var.pi_private_subnet_2.ip_address_range.ending_ip_address, cidrhost(var.pi_private_subnet_2.cidr, pow(2, (32 - tonumber(split("/", var.pi_private_subnet_2.cidr)[1]))) - 2))
  }
}

resource "ibm_pi_network" "private_subnet_3" {
  count = var.pi_private_subnet_3 != null ? 1 : 0

  depends_on           = [ibm_pi_network.private_subnet_2]
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_network_name      = var.pi_private_subnet_3.name
  pi_cidr              = var.pi_private_subnet_3.cidr
  pi_network_type      = "vlan"
  pi_advertise         = var.pi_private_subnet_3.advertise
  pi_arp_broadcast     = var.pi_private_subnet_3.arp_broadcast
  pi_dns               = var.pi_private_subnet_3.dns
  pi_network_mtu       = 9000
  pi_user_tags         = var.pi_tags != null ? var.pi_tags : []
  pi_ipaddress_range {
    pi_starting_ip_address = try(var.pi_private_subnet_3.ip_address_range.starting_ip_address, cidrhost(var.pi_private_subnet_3.cidr, 2))
    pi_ending_ip_address   = try(var.pi_private_subnet_3.ip_address_range.ending_ip_address, cidrhost(var.pi_private_subnet_3.cidr, pow(2, (32 - tonumber(split("/", var.pi_private_subnet_3.cidr)[1]))) - 2))
  }
}


#####################################################
# Create Public Subnet
#####################################################

resource "ibm_pi_network" "public_subnet" {
  count = var.pi_public_subnet_enable ? 1 : 0

  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_network_name      = "public_net"
  pi_network_type      = "pub-vlan"
  pi_network_mtu       = 9000
  pi_user_tags         = var.pi_tags != null ? var.pi_tags : []
}

output "pi_zone" {
  description = "Zone where PowerVS infrastructure is created."
  value       = var.pi_zone
}

output "pi_resource_group_name" {
  description = "IBM Cloud resource group name tagged to PowerVS Workspace."
  value       = var.pi_resource_group_name
}

output "pi_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = var.pi_workspace_name
}

output "pi_workspace_id" {
  description = "PowerVS infrastructure workspace id. The unique identifier of the new resource instance."
  value       = ibm_resource_instance.pi_workspace.id
}

output "pi_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  value       = ibm_resource_instance.pi_workspace.guid
}

output "pi_ssh_public_key" {
  description = "SSH public key name and value in created PowerVS infrastructure."
  value       = var.pi_ssh_public_key
}

output "pi_images" {
  description = "Object containing imported PowerVS image names and image ids."
  value       = local.pi_images
}

output "pi_private_subnet_1" {
  description = "Created PowerVS private subnet 1 details."
  value       = var.pi_private_subnet_1 != null ? merge(var.pi_private_subnet_1, { "id" = ibm_pi_network.private_subnet_1[0].network_id }) : var.pi_private_subnet_1
}

output "pi_private_subnet_2" {
  description = "Created PowerVS private subnet 2 details."
  value       = var.pi_private_subnet_2 != null ? merge(var.pi_private_subnet_2, { "id" = ibm_pi_network.private_subnet_2[0].network_id }) : var.pi_private_subnet_2
}

output "pi_private_subnet_3" {
  description = "Created PowerVS private subnet 3 details."
  value       = var.pi_private_subnet_3 != null ? merge(var.pi_private_subnet_3, { "id" = ibm_pi_network.private_subnet_3[0].network_id }) : var.pi_private_subnet_3
}

output "pi_public_subnet" {
  description = "Created PowerVS public subnet."
  value = var.pi_public_subnet_enable ? {
    "name" = ibm_pi_network.public_subnet[0].pi_network_name
  "id" = ibm_pi_network.public_subnet[0].network_id } : {}
}

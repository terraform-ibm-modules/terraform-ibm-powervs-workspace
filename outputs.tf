output "pi_zone" {
  description = "Zone where PowerVS infrastructure is created."
  value       = var.pi_zone
}

output "pi_resource_group_name" {
  description = "IBM Cloud resource group where PowerVS infrastructure is created."
  value       = var.pi_resource_group_name
}

output "pi_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = var.pi_workspace_name
}

output "pi_workspace_id" {
  description = "PowerVS infrastructure workspace id. The unique identifier of the new resource instance."
  value       = module.powervs_workspace.pi_workspace_id
}

output "pi_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  value       = module.powervs_workspace.pi_workspace_guid
}

output "pi_ssh_public_key" {
  description = "SSH public key name and value in created PowerVS infrastructure."
  value       = var.pi_ssh_public_key
}

output "pi_private_subnet_1" {
  description = "Created PowerVS private subnet 1 details."
  value       = module.powervs_workspace.pi_private_subnet_1
}

output "pi_private_subnet_2" {
  description = "Created PowerVS private subnet 2 details."
  value       = module.powervs_workspace.pi_private_subnet_2
}

output "pi_private_subnet_3" {
  description = "Created PowerVS private subnet 3 details."
  value       = module.powervs_workspace.pi_private_subnet_3
}

output "pi_public_subnet" {
  description = "Created PowerVS public subnet."
  value       = module.powervs_workspace.pi_public_subnet
}

output "pi_cloud_connection_count" {
  description = "Number of cloud connections configured in created PowerVS infrastructure."
  value       = local.pi_per_enabled ? 0 : var.pi_cloud_connection.count
}

output "pi_images" {
  description = "List of objects containing powervs image name and image id."
  value       = module.powervs_workspace.pi_images
}

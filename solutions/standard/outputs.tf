########################################################################################################################
# Outputs
########################################################################################################################

output "pi_zone" {
  description = "Zone where PowerVS infrastructure is created."
  value       = module.powervs_workspace.pi_zone
}

output "pi_resource_group_name" {
  description = "The name of the IBM Power Systems Virtual Server resource group used to organize and manage Power Infrastructure resources"
  value       = local.powervs_resource_group_name
}
output "existing_resource_group_id" {
  description = "The ID of the existing IBM Cloud resource group used for Power Systems resources"
  value       = var.existing_resource_group_id
}
output "resource_group_id" {
  description = "The ID of the  new resource group where PowerVS workspace is created."
  value       = local.powervs_resource_group_id
}
output "pi_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = module.powervs_workspace.pi_workspace_name
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
  description = "SSH public key name in created PowerVS infrastructure."
  value       = module.powervs_workspace.pi_ssh_public_key
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

output "pi_images" {
  description = "Object containing imported PowerVS image names and image ids."
  value       = module.powervs_workspace.pi_images
}

#####################################################
# Create IBM Cloud PowerVS SSH Key
#####################################################

resource "ibm_pi_key" "ssh_key" {
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_key_name          = var.pi_ssh_public_key.name
  pi_ssh_key           = var.pi_ssh_public_key.value
}

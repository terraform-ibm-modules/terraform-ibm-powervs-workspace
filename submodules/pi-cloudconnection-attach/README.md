# Submodule pi-cloudconnection-attach

This submodule attaches PowerVS subnets to cloud connections. Maximum of 3 private subnets can be attached to CCs.

## Usage
```hcl
provider "ibm" {
region           = "sao"
zone             = "sao01"
ibmcloud_api_key = "your api key" != null ? "your api key" : null
}

module "powervs_cloud_connection_attach" {
  source     = "./submodules/pi-cloudconnection-attach"

  pi_workspace_guid         = var.pi_workspace_guid
  pi_cloud_connection_count = var.pi_cloud_connection_count
  pi_private_subnet_ids     = var.pi_private_subnet_ids
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_pi_cloud_connection_network_attach.private_subnet_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection_network_attach) | resource |
| [ibm_pi_cloud_connection_network_attach.private_subnet_1_redundant](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection_network_attach) | resource |
| [ibm_pi_cloud_connection_network_attach.private_subnet_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection_network_attach) | resource |
| [ibm_pi_cloud_connection_network_attach.private_subnet_2_redundant](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection_network_attach) | resource |
| [ibm_pi_cloud_connection_network_attach.private_subnet_3](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection_network_attach) | resource |
| [ibm_pi_cloud_connection_network_attach.private_subnet_3_redundant](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection_network_attach) | resource |
| [ibm_pi_cloud_connections.cloud_connection_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_cloud_connections) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_cloud_connection_count"></a> [pi\_cloud\_connection\_count](#input\_pi\_cloud\_connection\_count) | Number of cloud connections where private networks should be attached to. Default is to use redundant cloud connection pair. | `number` | n/a | yes |
| <a name="input_pi_private_subnet_ids"></a> [pi\_private\_subnet\_ids](#input\_pi\_private\_subnet\_ids) | List of IBM Cloud PowerVS subnet ids to be attached to Cloud connection. Maximum of 3 subnets in a list are supported. | `list(any)` | n/a | yes |
| <a name="input_pi_workspace_guid"></a> [pi\_workspace\_guid](#input\_pi\_workspace\_guid) | Existing IBM Cloud PowerVS Workspace GUID. | `string` | n/a | yes |

### Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

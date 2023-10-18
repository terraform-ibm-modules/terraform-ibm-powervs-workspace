# Submodule pi-cloudconnection-create

This submodule creates Cloud Connections and attaches the cloud connections to the Transit gateway if transit gateway id is not null.If TGW id is set to null, only CCs will be created and will not attach the CCs to TGW.

## Usage
```hcl
provider "ibm" {
region           = "sao"
zone             = "sao01"
ibmcloud_api_key = "your api key" != null ? "your api key" : null
}

module "powervs_cloud_connection_create" {
  source = "./submodules/pi-cloudconnection-create"

  pi_zone             = var.pi_zone
  pi_workspace_guid   = var.pi_workspace_guid
  transit_gateway_id  = var.transit_gateway_id
  pi_cloud_connection = var.pi_cloud_connection
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_pi_cloud_connection.cloud_connection](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection) | resource |
| [ibm_pi_cloud_connection.cloud_connection_backup](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection) | resource |
| [ibm_tg_connection.ibm_tg_cc_connection_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_connection.ibm_tg_cc_connection_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [time_sleep.dl_1_resource_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.dl_2_resource_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [ibm_dl_gateway.gateway_ds_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/dl_gateway) | data source |
| [ibm_dl_gateway.gateway_ds_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/dl_gateway) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_cloud_connection"></a> [pi\_cloud\_connection](#input\_pi\_cloud\_connection) | Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global\_routing (true or false), metered (true or false). Not applicable for PER enabled DC and CCs will not be created. | <pre>object({<br>    count          = number<br>    speed          = number<br>    global_routing = bool<br>    metered        = bool<br>  })</pre> | n/a | yes |
| <a name="input_pi_workspace_guid"></a> [pi\_workspace\_guid](#input\_pi\_workspace\_guid) | Existing IBM Cloud PowerVS Workspace GUID. | `string` | n/a | yes |
| <a name="input_pi_zone"></a> [pi\_zone](#input\_pi\_zone) | IBM Cloud PowerVS Zone. | `string` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | ID of the existing transit gateway. This is required to attach the CCs( Non PER environment) to TGW. Can be set to null and CCs will not be attached to TGW but it will be created. | `string` | n/a | yes |

### Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

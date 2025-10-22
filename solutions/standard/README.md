# Basic example

An basic example that will provision the following:
- A new resource group if one is not passed in.
- A new transit gateway.
- A new PowerVS workspace.
- A new PowerVS public SSH key.
- 3 new PowerVS private subnets.
- A new PowerVS public subnet.
- Attaches the PowerVS workspace to Transit gateway.
- Optionally import up to 3 custom images from Cloud Object Storage.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | =1.82.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_powervs_workspace"></a> [powervs\_workspace](#module\_powervs\_workspace) | ../../ | n/a |

### Resources

| Name | Type |
|------|------|
| [ibm_resource_group.resource_group](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.82.1/docs/resources/resource_group) | resource |
| [ibm_tg_gateway.transit_gateway](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.82.1/docs/resources/tg_gateway) | resource |
| [ibm_resource_group.existing](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.82.1/docs/data-sources/resource_group) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_new_resource_group_name"></a> [create\_new\_resource\_group\_name](#input\_create\_new\_resource\_group\_name) | Name of the new resource group to create if no existing name or ID is provided | `string` | `null` | no |
| <a name="input_create_transit_gateway"></a> [create\_transit\_gateway](#input\_create\_transit\_gateway) | Set to true to create a Transit Gateway for the PowerVS workspace and attach it. | `bool` | `true` | no |
| <a name="input_existing_resource_group_id"></a> [existing\_resource\_group\_id](#input\_existing\_resource\_group\_id) | The ID of an existing resource group to provision resources in to. If not set a new resource group  will be created using the prefix variable | `string` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of an existing resource group to provision resources in to. If not set a new resource group will be created using the prefix variable | `string` | `null` | no |
| <a name="input_existing_transit_gateway_id"></a> [existing\_transit\_gateway\_id](#input\_existing\_transit\_gateway\_id) | Optional: ID of an existing Transit Gateway to use instead of creating a new one | `string` | `null` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud API Key used to authenticate the IBM Cloud provider. | `string` | n/a | yes |
| <a name="input_powervs_custom_image_cos_configuration"></a> [powervs\_custom\_image\_cos\_configuration](#input\_powervs\_custom\_image\_cos\_configuration) | Cloud Object Storage bucket containing the custom PowerVS images. Images will be imported into the PowerVS Workspace.<br/>      bucket\_name: string, name of the COS bucket<br/>      bucket\_access: string, possible values: "public", "private" (private requires powervs\_custom\_image\_cos\_service\_credentials)<br/>      bucket\_region: string, COS bucket region | <pre>object({<br/>    bucket_name   = string<br/>    bucket_access = string<br/>    bucket_region = string<br/>  })</pre> | <pre>{<br/>  "bucket_access": "",<br/>  "bucket_name": "",<br/>  "bucket_region": ""<br/>}</pre> | no |
| <a name="input_powervs_custom_image_cos_service_credentials"></a> [powervs\_custom\_image\_cos\_service\_credentials](#input\_powervs\_custom\_image\_cos\_service\_credentials) | Service credentials for the Cloud Object Storage bucket containing the custom PowerVS images. The bucket must have HMAC credentials enabled. Click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials) for a json example of a service credential. | `string` | `null` | no |
| <a name="input_powervs_custom_images"></a> [powervs\_custom\_images](#input\_powervs\_custom\_images) | Optionally import up to three custom images from Cloud Object Storage into PowerVS workspace. Requires 'powervs\_custom\_image\_cos\_configuration' to be set. image\_name: string, must be unique. Name of image inside PowerVS workspace. file\_name: string, object key of image inside COS bucket. storage\_tier: string, storage tier which image will be stored in after import. Supported values: tier0, tier1, tier3, tier5k. sap\_type: optional string, Supported values: null, Hana, Netweaver, use null for non-SAP image. | <pre>object({<br/>    powervs_custom_image1 = object({<br/>      image_name   = string<br/>      file_name    = string<br/>      storage_tier = string<br/>      sap_type     = optional(string)<br/>    }),<br/>    powervs_custom_image2 = object({<br/>      image_name   = string<br/>      file_name    = string<br/>      storage_tier = string<br/>      sap_type     = optional(string)<br/>    }),<br/>    powervs_custom_image3 = object({<br/>      image_name   = string<br/>      file_name    = string<br/>      storage_tier = string<br/>      sap_type     = optional(string)<br/>    })<br/>  })</pre> | <pre>{<br/>  "powervs_custom_image1": {<br/>    "file_name": "",<br/>    "image_name": "",<br/>    "sap_type": null,<br/>    "storage_tier": ""<br/>  },<br/>  "powervs_custom_image2": {<br/>    "file_name": "",<br/>    "image_name": "",<br/>    "sap_type": null,<br/>    "storage_tier": ""<br/>  },<br/>  "powervs_custom_image3": {<br/>    "file_name": "",<br/>    "image_name": "",<br/>    "sap_type": null,<br/>    "storage_tier": ""<br/>  }<br/>}</pre> | no |
| <a name="input_powervs_private_subnet_1"></a> [powervs\_private\_subnet\_1](#input\_powervs\_private\_subnet\_1) | IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br/>    name          = string<br/>    cidr          = string<br/>    advertise     = optional(string)<br/>    arp_broadcast = optional(string)<br/>  })</pre> | <pre>{<br/>  "cidr": "10.51.0.0/24",<br/>  "name": "sub_1"<br/>}</pre> | no |
| <a name="input_powervs_private_subnet_2"></a> [powervs\_private\_subnet\_2](#input\_powervs\_private\_subnet\_2) | IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br/>    name          = string<br/>    cidr          = string<br/>    advertise     = optional(string)<br/>    arp_broadcast = optional(string)<br/>  })</pre> | <pre>{<br/>  "cidr": "",<br/>  "name": ""<br/>}</pre> | no |
| <a name="input_powervs_private_subnet_3"></a> [powervs\_private\_subnet\_3](#input\_powervs\_private\_subnet\_3) | IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br/>    name          = string<br/>    cidr          = string<br/>    advertise     = optional(string)<br/>    arp_broadcast = optional(string)<br/>  })</pre> | <pre>{<br/>  "cidr": "",<br/>  "name": ""<br/>}</pre> | no |
| <a name="input_powervs_public_network_enable"></a> [powervs\_public\_network\_enable](#input\_powervs\_public\_network\_enable) | IBM Cloud PowerVS Public Network. Set to true to enable this. | `bool` | `false` | no |
| <a name="input_powervs_ssh_public_key"></a> [powervs\_ssh\_public\_key](#input\_powervs\_ssh\_public\_key) | Value of the Public SSH key to create inside the PowerVS workspace. | `string` | n/a | yes |
| <a name="input_powervs_tags"></a> [powervs\_tags](#input\_powervs\_tags) | List of Tag names for IBM Cloud PowerVS workspace. | `list(string)` | `[]` | no |
| <a name="input_powervs_workspace_name"></a> [powervs\_workspace\_name](#input\_powervs\_workspace\_name) | Provide unique name for the PowerVS workspace to be created. | `string` | `"powervs-workspace"` | no |
| <a name="input_powervs_zone"></a> [powervs\_zone](#input\_powervs\_zone) | IBM Cloud PowerVS zone where the PowerVS workspace will be created. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to append to all resources . | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_images"></a> [pi\_images](#output\_pi\_images) | Object containing imported PowerVS image names and image ids. |
| <a name="output_pi_private_subnet_1"></a> [pi\_private\_subnet\_1](#output\_pi\_private\_subnet\_1) | Created PowerVS private subnet 1 details. |
| <a name="output_pi_private_subnet_2"></a> [pi\_private\_subnet\_2](#output\_pi\_private\_subnet\_2) | Created PowerVS private subnet 2 details. |
| <a name="output_pi_private_subnet_3"></a> [pi\_private\_subnet\_3](#output\_pi\_private\_subnet\_3) | Created PowerVS private subnet 3 details. |
| <a name="output_pi_public_subnet"></a> [pi\_public\_subnet](#output\_pi\_public\_subnet) | Created PowerVS public subnet. |
| <a name="output_pi_resource_group_name"></a> [pi\_resource\_group\_name](#output\_pi\_resource\_group\_name) | IBM Cloud resource group where PowerVS infrastructure is created. |
| <a name="output_pi_ssh_public_key"></a> [pi\_ssh\_public\_key](#output\_pi\_ssh\_public\_key) | SSH public key name in created PowerVS infrastructure. |
| <a name="output_pi_workspace_guid"></a> [pi\_workspace\_guid](#output\_pi\_workspace\_guid) | PowerVS infrastructure workspace guid. The GUID of the resource instance. |
| <a name="output_pi_workspace_id"></a> [pi\_workspace\_id](#output\_pi\_workspace\_id) | PowerVS infrastructure workspace id. The unique identifier of the new resource instance. |
| <a name="output_pi_workspace_name"></a> [pi\_workspace\_name](#output\_pi\_workspace\_name) | PowerVS infrastructure workspace name. |
| <a name="output_pi_zone"></a> [pi\_zone](#output\_pi\_zone) | Zone where PowerVS infrastructure is created. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

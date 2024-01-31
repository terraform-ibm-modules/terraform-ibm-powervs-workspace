# Module pi-workspace

This module provisions the following resources in IBM Cloud:

- Creates an IBM® Power Virtual Server (PowerVS) workspace.
- Creates a Public SSH key in Power Virtual Server (PowerVS) workspace.
- Optionally create one or two or three private subnets.
- Optionally create one public subnet.
- Import up to 6 catalog Stock images from IBM cloud.

## Usage
```hcl
provider "ibm" {
region           = "sao"
zone             = "sao01"
ibmcloud_api_key = "your api key" != null ? "your api key" : null
}

module "powervs_instance" {
  source     = "terraform-ibm-modules/powervs-workspace/ibm//modules//pi-workspace"
  version    = "x.x.x" #replace x.x.x with latest git release


  pi_zone                 = var.pi_zone
  pi_resource_group_name  = var.pi_resource_group_name
  pi_workspace_name       = var.pi_workspace_name
  pi_tags                 = var.pi_tags
  pi_image_names          = var.pi_image_names
  pi_ssh_public_key       = var.pi_ssh_public_key
  pi_private_subnet_1     = var.pi_private_subnet_1
  pi_private_subnet_2     = var.pi_private_subnet_2
  pi_private_subnet_3     = var.pi_private_subnet_3
  pi_public_subnet_enable = var.pi_public_subnet_enable
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
| [ibm_pi_image.import_images](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_image) | resource |
| [ibm_pi_key.ssh_key](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_key) | resource |
| [ibm_pi_network.private_subnet_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_network.private_subnet_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_network.private_subnet_3](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_network.public_subnet](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_resource_instance.pi_workspace](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [time_sleep.wait_30_sec](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [ibm_pi_catalog_images.catalog_images_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_catalog_images) | data source |
| [ibm_resource_group.resource_group_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_group) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_image_names"></a> [pi\_image\_names](#input\_pi\_image\_names) | List of images to be imported into cloud account from catalog images. Supported values can be found [here](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-workspace/blob/main/docs/catalog_images_list.md) | `list(string)` | n/a | yes |
| <a name="input_pi_private_subnet_1"></a> [pi\_private\_subnet\_1](#input\_pi\_private\_subnet\_1) | IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br>    name = string<br>    cidr = string<br>  })</pre> | n/a | yes |
| <a name="input_pi_private_subnet_2"></a> [pi\_private\_subnet\_2](#input\_pi\_private\_subnet\_2) | IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br>    name = string<br>    cidr = string<br>  })</pre> | n/a | yes |
| <a name="input_pi_private_subnet_3"></a> [pi\_private\_subnet\_3](#input\_pi\_private\_subnet\_3) | IBM Cloud PowerVS third private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br>    name = string<br>    cidr = string<br>  })</pre> | n/a | yes |
| <a name="input_pi_public_subnet_enable"></a> [pi\_public\_subnet\_enable](#input\_pi\_public\_subnet\_enable) | IBM Cloud PowerVS Public Network. Set to true to enable this. | `bool` | `false` | no |
| <a name="input_pi_resource_group_name"></a> [pi\_resource\_group\_name](#input\_pi\_resource\_group\_name) | Existing Resource Group Name. | `string` | n/a | yes |
| <a name="input_pi_ssh_public_key"></a> [pi\_ssh\_public\_key](#input\_pi\_ssh\_public\_key) | Name and value of the Public SSH key to create. | <pre>object({<br>    name  = string<br>    value = string<br>  })</pre> | n/a | yes |
| <a name="input_pi_tags"></a> [pi\_tags](#input\_pi\_tags) | List of Tag names for IBM Cloud PowerVS workspace. | `list(string)` | n/a | yes |
| <a name="input_pi_workspace_name"></a> [pi\_workspace\_name](#input\_pi\_workspace\_name) | Name of IBM Cloud PowerVS workspace which will be created. | `string` | n/a | yes |
| <a name="input_pi_zone"></a> [pi\_zone](#input\_pi\_zone) | IBM Cloud PowerVS Zone. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_images"></a> [pi\_images](#output\_pi\_images) | Object containing imported PowerVS image names and image ids. |
| <a name="output_pi_private_subnet_1"></a> [pi\_private\_subnet\_1](#output\_pi\_private\_subnet\_1) | Created PowerVS private subnet 1 details. |
| <a name="output_pi_private_subnet_2"></a> [pi\_private\_subnet\_2](#output\_pi\_private\_subnet\_2) | Created PowerVS private subnet 2 details. |
| <a name="output_pi_private_subnet_3"></a> [pi\_private\_subnet\_3](#output\_pi\_private\_subnet\_3) | Created PowerVS private subnet 3 details. |
| <a name="output_pi_public_subnet"></a> [pi\_public\_subnet](#output\_pi\_public\_subnet) | Created PowerVS public subnet. |
| <a name="output_pi_workspace_guid"></a> [pi\_workspace\_guid](#output\_pi\_workspace\_guid) | PowerVS infrastructure workspace guid. The GUID of the resource instance. |
| <a name="output_pi_workspace_id"></a> [pi\_workspace\_id](#output\_pi\_workspace\_id) | PowerVS infrastructure workspace id. The unique identifier of the new resource instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

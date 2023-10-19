# PowerVS Workspace

[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-powervs-workspace?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-workspace/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)


## Summary
This root module automates and provisions a IBM Power Virtual Server Workspace with following components:

- Creates an IBM® Power Virtual Server (PowerVS) workspace.
- Creates an SSH key.
- Optionally create one or two or three private subnets.
- Optionally create one public subnet.
- Optionally create one or two [IBM Cloud connections](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections) and attaches the private subnets to the IBM Cloud connections in Non PER DC.
- Optionally attach the IBM Cloud connections to a transit gateway in Non PER DC.
- Optionally attach the PowerVS workspace to transit gateway in PER DC.
- Optionally import up to 6 catalog images.

<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-powervs-workspace](#terraform-ibm-powervs-workspace)
* [Examples](./examples)
    * [Basic example](./examples/basic)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


## terraform-ibm-powervs-workspace

### Usage

```hcl
provider "ibm" {
  region           = var.pi_region
  zone             = var.pi_zone
  ibmcloud_api_key = var.ibmcloud_api_key != null ? var.ibmcloud_api_key : null
}

module "power-workspace" {
  source  = "terraform-ibm-modules/powervs-workspace/ibm"
  version = "latest" # Replace "latest" with a release version to lock into a specific release

  pi_zone                        = var.pi_zone
  pi_resource_group_name         = var.pi_resource_group_name
  pi_workspace_name              = var.pi_workspace_name
  pi_ssh_public_key              = var.pi_ssh_public_key
  pi_cloud_connection            = var.pi_cloud_connection             #(optional, default check vars)
  pi_private_subnet_1            = var.pi_private_subnet_1             #(optional, default [])
  pi_private_subnet_2            = var.pi_private_subnet_2             #(optional, default [])
  pi_private_subnet_3            = var.pi_private_subnet_3             #(optional, default null)
  pi_public_subnet_enable        = var.pi_public_subnet_enable         #(optional, default false)
  pi_transit_gateway_connection  = var.pi_transit_gateway_connection   #(optional, default check vars)
  pi_tags                        = var.pi_tags                         #(optional, default [])
  pi_image_names                 = var.pi_image_names                  #(optional, default [])
}

```

## Required IAM access policies

You need the following permissions to run this module.

- Account Management
    - **Resource Group** service
        - `Viewer` platform access
    - IAM Services
        - **Workspace for Power Virtual Server** service
        - **Power Virtual Server** service
            - `Editor` platform access
        - **VPC Infrastructure Services** service
            - `Editor` platform access
        - **Transit Gateway** service
            - `Editor` platform access
        - **Direct Link** service
            - `Editor` platform access


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_powervs_cloud_connection_attach"></a> [powervs\_cloud\_connection\_attach](#module\_powervs\_cloud\_connection\_attach) | ./submodules/pi-cloudconnection-attach | n/a |
| <a name="module_powervs_cloud_connection_create"></a> [powervs\_cloud\_connection\_create](#module\_powervs\_cloud\_connection\_create) | ./submodules/pi-cloudconnection-create | n/a |
| <a name="module_powervs_workspace"></a> [powervs\_workspace](#module\_powervs\_workspace) | ./submodules/pi-workspace | n/a |

### Resources

| Name | Type |
|------|------|
| [ibm_tg_connection.tg_powervs_workspace_attach](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_cloud_connection"></a> [pi\_cloud\_connection](#input\_pi\_cloud\_connection) | Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global\_routing (true or false), metered (true or false). Not applicable for PER enabled DC and CCs will not be created. | <pre>object({<br>    count          = number<br>    speed          = number<br>    global_routing = bool<br>    metered        = bool<br>  })</pre> | <pre>{<br>  "count": 2,<br>  "global_routing": true,<br>  "metered": true,<br>  "speed": 5000<br>}</pre> | no |
| <a name="input_pi_image_names"></a> [pi\_image\_names](#input\_pi\_image\_names) | List of images to be imported into cloud account from catalog images. Max number of images that can be imported is 6 images. Can be set to null and images will not be imported. Supported values can be found [here](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-workspace/blob/main/docs/catalog_images_list.md) | `list(string)` | `null` | no |
| <a name="input_pi_private_subnet_1"></a> [pi\_private\_subnet\_1](#input\_pi\_private\_subnet\_1) | IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br>    name = string<br>    cidr = string<br>  })</pre> | <pre>{<br>  "cidr": "10.51.0.0/24",<br>  "name": "sub_1"<br>}</pre> | no |
| <a name="input_pi_private_subnet_2"></a> [pi\_private\_subnet\_2](#input\_pi\_private\_subnet\_2) | IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br>    name = string<br>    cidr = string<br>  })</pre> | `null` | no |
| <a name="input_pi_private_subnet_3"></a> [pi\_private\_subnet\_3](#input\_pi\_private\_subnet\_3) | IBM Cloud PowerVS third private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br>    name = string<br>    cidr = string<br>  })</pre> | `null` | no |
| <a name="input_pi_public_subnet_enable"></a> [pi\_public\_subnet\_enable](#input\_pi\_public\_subnet\_enable) | IBM Cloud PowerVS Public Network. Set to true to enable this. | `bool` | `false` | no |
| <a name="input_pi_resource_group_name"></a> [pi\_resource\_group\_name](#input\_pi\_resource\_group\_name) | Existing Resource Group Name. | `string` | n/a | yes |
| <a name="input_pi_ssh_public_key"></a> [pi\_ssh\_public\_key](#input\_pi\_ssh\_public\_key) | Name and value of the Public SSH key to create. | <pre>object({<br>    name  = string<br>    value = string<br>  })</pre> | n/a | yes |
| <a name="input_pi_tags"></a> [pi\_tags](#input\_pi\_tags) | List of Tag names for IBM Cloud PowerVS workspace. Can be set to null. | `list(string)` | `null` | no |
| <a name="input_pi_transit_gateway_connection"></a> [pi\_transit\_gateway\_connection](#input\_pi\_transit\_gateway\_connection) | Set enable to true and provide ID of the existing transit gateway to attach the CCs( Non PER DC) to TGW or to attach PowerVS workspace to TGW (PER DC). If enable is false, CCs will not be attached to TGW , or PowerVS workspace will not be attached to TGW, but CCs in (Non PER DC) will be created. | <pre>object({<br>    enable             = bool<br>    transit_gateway_id = string<br>  })</pre> | <pre>{<br>  "enable": false,<br>  "transit_gateway_id": ""<br>}</pre> | no |
| <a name="input_pi_workspace_name"></a> [pi\_workspace\_name](#input\_pi\_workspace\_name) | Name of IBM Cloud PowerVS workspace which will be created. | `string` | n/a | yes |
| <a name="input_pi_zone"></a> [pi\_zone](#input\_pi\_zone) | IBM Cloud PowerVS zone. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_cloud_connection_count"></a> [pi\_cloud\_connection\_count](#output\_pi\_cloud\_connection\_count) | Number of cloud connections configured in created PowerVS infrastructure. |
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

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.

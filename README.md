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
- Optionally imports up to three custom images from Cloud Object Storage.
- Optionally create one or two or three private subnets.
- Optionally create one public subnet.
- Optionally attach the PowerVS workspace to transit gateway.


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

  pi_zone                                 = var.pi_zone
  pi_resource_group_name                  = var.pi_resource_group_name                  #(optional, default null,pi_resource_group_name or pi_resource_group_id required)
  pi_resource_group_id                    = var.pi_resource_group_id                    #(optional, default null,pi_resource_group_name or pi_resource_group_id required)
  pi_workspace_name                       = var.pi_workspace_name
  pi_ssh_public_key                       = var.pi_ssh_public_key
  pi_transit_gateway_connection           = var.pi_transit_gateway_connection           #(optional, default check vars)
  pi_private_subnet_1                     = var.pi_private_subnet_1                     #(optional, default null)
  pi_private_subnet_2                     = var.pi_private_subnet_2                     #(optional, default null)
  pi_private_subnet_3                     = var.pi_private_subnet_3                     #(optional, default null)
  pi_public_subnet_enable                 = var.pi_public_subnet_enable                 #(optional, default false)
  pi_tags                                 = var.pi_tags                                 #(optional, default null)
  pi_custom_image1                        = var.pi_custom_image1                        #(optional, default null)
  pi_custom_image2                        = var.pi_custom_image2                        #(optional, default null)
  pi_custom_image3                        = var.pi_custom_image3                        #(optional, default null)
  pi_custom_image_cos_configuration       = var.pi_custom_image_cos_configuration       #(optional, default null)
  pi_custom_image_cos_service_credentials = var.pi_custom_image_cos_service_credentials #(optional, default null)
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.71.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_pi_image.pi_custom_image1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_image) | resource |
| [ibm_pi_image.pi_custom_image2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_image) | resource |
| [ibm_pi_image.pi_custom_image3](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_image) | resource |
| [ibm_pi_key.ssh_key](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_key) | resource |
| [ibm_pi_network.private_subnet_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_network.private_subnet_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_network.private_subnet_3](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_network.public_subnet](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_resource_instance.pi_workspace](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_tg_connection.tg_powervs_workspace_attach](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [time_sleep.wait_30_sec](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [ibm_resource_group.resource_group_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_group) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_custom_image1"></a> [pi\_custom\_image1](#input\_pi\_custom\_image1) | Optional custom image to import from Cloud Object Storage into PowerVS workspace.<br/>      image\_name: string, must be unique image name how the image will be named inside PowerVS workspace<br/>      file\_name: string, full file name of the image inside COS bucket<br/>      storage\_tier: string, storage tier which the image will be stored in after import. Supported values are: "tier0", "tier1", "tier3", "tier5k".<br/>      sap\_type: optional string, "Hana", "Netweaver", don't use it for non-SAP image. | <pre>object({<br/>    image_name   = string<br/>    file_name    = string<br/>    storage_tier = string<br/>    sap_type     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_pi_custom_image2"></a> [pi\_custom\_image2](#input\_pi\_custom\_image2) | Optional custom image to import from Cloud Object Storage into PowerVS workspace.<br/>      image\_name: string, must be unique image name how the image will be named inside PowerVS workspace<br/>      file\_name: string, full file name of the image inside COS bucket<br/>      storage\_tier: string, storage tier which the image will be stored in after import. Supported values are: "tier0", "tier1", "tier3", "tier5k".<br/>      sap\_type: optional string, "Hana", "Netweaver", don't use it for non-SAP image. | <pre>object({<br/>    image_name   = string<br/>    file_name    = string<br/>    storage_tier = string<br/>    sap_type     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_pi_custom_image3"></a> [pi\_custom\_image3](#input\_pi\_custom\_image3) | Optional custom image to import from Cloud Object Storage into PowerVS workspace.<br/>      image\_name: string, must be unique image name how the image will be named inside PowerVS workspace<br/>      file\_name: string, full file name of the image inside COS bucket<br/>      storage\_tier: string, storage tier which the image will be stored in after import. Supported values are: "tier0", "tier1", "tier3", "tier5k".<br/>      sap\_type: optional string, "Hana", "Netweaver", don't use it for non-SAP image. | <pre>object({<br/>    image_name   = string<br/>    file_name    = string<br/>    storage_tier = string<br/>    sap_type     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_pi_custom_image_cos_configuration"></a> [pi\_custom\_image\_cos\_configuration](#input\_pi\_custom\_image\_cos\_configuration) | Cloud Object Storage bucket containing the custom PowerVS images. Images will be imported into the PowerVS Workspace.<br/>      bucket\_name: string, name of the COS bucket<br/>      bucket\_access: string, possible values: "public", "private" (private requires pi\_custom\_image\_cos\_service\_credentials)<br/>      bucket\_region: string, COS bucket region | <pre>object({<br/>    bucket_name   = string<br/>    bucket_access = string<br/>    bucket_region = string<br/>  })</pre> | `null` | no |
| <a name="input_pi_custom_image_cos_service_credentials"></a> [pi\_custom\_image\_cos\_service\_credentials](#input\_pi\_custom\_image\_cos\_service\_credentials) | Service credentials for the Cloud Object Storage bucket containing the custom PowerVS images. The bucket must have HMAC credentials enabled. Click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials) for a json example of a service credential. | `string` | `null` | no |
| <a name="input_pi_private_subnet_1"></a> [pi\_private\_subnet\_1](#input\_pi\_private\_subnet\_1) | IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br/>    name          = string<br/>    cidr          = string<br/>    advertise     = optional(string)<br/>    arp_broadcast = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_pi_private_subnet_2"></a> [pi\_private\_subnet\_2](#input\_pi\_private\_subnet\_2) | IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br/>    name          = string<br/>    cidr          = string<br/>    advertise     = optional(string)<br/>    arp_broadcast = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_pi_private_subnet_3"></a> [pi\_private\_subnet\_3](#input\_pi\_private\_subnet\_3) | IBM Cloud PowerVS third private subnet name and cidr which will be created. Set value to null to not create this subnet. | <pre>object({<br/>    name          = string<br/>    cidr          = string<br/>    advertise     = optional(string)<br/>    arp_broadcast = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_pi_public_subnet_enable"></a> [pi\_public\_subnet\_enable](#input\_pi\_public\_subnet\_enable) | IBM Cloud PowerVS Public Network. Set to true to enable this. | `bool` | `false` | no |
| <a name="input_pi_resource_group_id"></a> [pi\_resource\_group\_id](#input\_pi\_resource\_group\_id) | Existing Resource Group Id. Conflicts with pi\_resource\_group\_name. | `string` | `null` | no |
| <a name="input_pi_resource_group_name"></a> [pi\_resource\_group\_name](#input\_pi\_resource\_group\_name) | Existing Resource Group Name. Conflicts with pi\_resource\_group\_id. | `string` | `null` | no |
| <a name="input_pi_ssh_public_key"></a> [pi\_ssh\_public\_key](#input\_pi\_ssh\_public\_key) | Name, value, and scope of the Public SSH key to create in PowerVS workspace. Allowed values for scope: 'account', 'workspace'. | <pre>object({<br/>    name  = string<br/>    value = string<br/>    scope = optional(string, "account")<br/>  })</pre> | n/a | yes |
| <a name="input_pi_tags"></a> [pi\_tags](#input\_pi\_tags) | List of Tag names for IBM Cloud PowerVS workspace. Can be set to null. | `list(string)` | `null` | no |
| <a name="input_pi_transit_gateway_connection"></a> [pi\_transit\_gateway\_connection](#input\_pi\_transit\_gateway\_connection) | Set enable to true and provide ID of the existing transit gateway to attach the CCs( Non PER DC) to TGW or to attach PowerVS workspace to TGW (PER DC). If enable is false, CCs will not be attached to TGW , or PowerVS workspace will not be attached to TGW, but CCs in (Non PER DC) will be created. | <pre>object({<br/>    enable             = bool<br/>    transit_gateway_id = string<br/>  })</pre> | <pre>{<br/>  "enable": false,<br/>  "transit_gateway_id": ""<br/>}</pre> | no |
| <a name="input_pi_workspace_name"></a> [pi\_workspace\_name](#input\_pi\_workspace\_name) | Name of IBM Cloud PowerVS workspace which will be created. | `string` | n/a | yes |
| <a name="input_pi_zone"></a> [pi\_zone](#input\_pi\_zone) | IBM Cloud PowerVS zone. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_images"></a> [pi\_images](#output\_pi\_images) | Object containing imported PowerVS image names and image ids. |
| <a name="output_pi_private_subnet_1"></a> [pi\_private\_subnet\_1](#output\_pi\_private\_subnet\_1) | Created PowerVS private subnet 1 details. |
| <a name="output_pi_private_subnet_2"></a> [pi\_private\_subnet\_2](#output\_pi\_private\_subnet\_2) | Created PowerVS private subnet 2 details. |
| <a name="output_pi_private_subnet_3"></a> [pi\_private\_subnet\_3](#output\_pi\_private\_subnet\_3) | Created PowerVS private subnet 3 details. |
| <a name="output_pi_public_subnet"></a> [pi\_public\_subnet](#output\_pi\_public\_subnet) | Created PowerVS public subnet. |
| <a name="output_pi_resource_group_name"></a> [pi\_resource\_group\_name](#output\_pi\_resource\_group\_name) | IBM Cloud resource group name tagged to PowerVS Workspace. |
| <a name="output_pi_ssh_public_key"></a> [pi\_ssh\_public\_key](#output\_pi\_ssh\_public\_key) | SSH public key name and value in created PowerVS infrastructure. |
| <a name="output_pi_workspace_guid"></a> [pi\_workspace\_guid](#output\_pi\_workspace\_guid) | PowerVS infrastructure workspace guid. The GUID of the resource instance. |
| <a name="output_pi_workspace_id"></a> [pi\_workspace\_id](#output\_pi\_workspace\_id) | PowerVS infrastructure workspace id. The unique identifier of the new resource instance. |
| <a name="output_pi_workspace_name"></a> [pi\_workspace\_name](#output\_pi\_workspace\_name) | PowerVS infrastructure workspace name. |
| <a name="output_pi_zone"></a> [pi\_zone](#output\_pi\_zone) | Zone where PowerVS infrastructure is created. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.

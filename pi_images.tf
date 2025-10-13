#####################################################
# Import Custom Image from COS
#####################################################

# locals {
#   pi_custom_image_cos_service_credentials = var.pi_custom_image_cos_configuration != null ? var.pi_custom_image_cos_configuration.bucket_access == "private" ? jsondecode(var.pi_custom_image_cos_service_credentials) : null : null
# }

# resource "ibm_pi_image" "pi_custom_image1" {
#   count = var.pi_custom_image1 != null ? 1 : 0
#   # count                     = length(var.pi_custom_image1) > 3 ? 3 : length(var.pi_custom_image1)
#   pi_image_name             = var.pi_custom_image1.image_name
#   pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
#   pi_image_bucket_name      = var.pi_custom_image_cos_configuration.bucket_name
#   pi_image_bucket_access    = var.pi_custom_image_cos_configuration.bucket_access
#   pi_image_bucket_region    = var.pi_custom_image_cos_configuration.bucket_region
#   pi_image_bucket_file_name = var.pi_custom_image1.file_name
#   pi_image_storage_type     = var.pi_custom_image1.storage_tier
#   pi_image_access_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.pi_custom_image_cos_service_credentials.cos_hmac_keys.access_key_id : null
#   pi_image_secret_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.pi_custom_image_cos_service_credentials.cos_hmac_keys.secret_access_key : null
#   pi_user_tags              = var.pi_tags != null ? var.pi_tags : []

#   dynamic "pi_image_import_details" {
#     # make pi_image_import_details optional
#     for_each = var.pi_custom_image1.sap_type != null ? [var.pi_custom_image1.sap_type] : []

#     content {
#       license_type = "byol"
#       product      = var.pi_custom_image1.sap_type
#       vendor       = "SAP"
#     }
#   }
# }

### converting credentials to json type
locals {
  cos_creds = var.pi_custom_image_cos_service_credentials != null ? jsondecode(var.pi_custom_image_cos_service_credentials) : null
}


# resource "ibm_pi_image" "pi_custom_images" {
#   for_each = {
#     for idx, image in var.pi_custom_images :
#     "${image.image_name}_${idx}" => image
#   }
#   depends_on                =
#   pi_image_name             = each.value.image_name
#   pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
#   pi_image_bucket_name      = var.pi_custom_image_cos_configuration.bucket_name
#   pi_image_bucket_access    = var.pi_custom_image_cos_configuration.bucket_access
#   pi_image_bucket_region    = var.pi_custom_image_cos_configuration.bucket_region
#   pi_image_bucket_file_name = each.value.file_name
#   pi_image_storage_type     = each.value.storage_tier
#   pi_image_access_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.cos_creds.cos_hmac_keys.access_key_id : null
#   pi_image_secret_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.cos_creds.cos_hmac_keys.secret_access_key : null
#   pi_user_tags              = var.pi_tags != null ? var.pi_tags : []

#   dynamic "pi_image_import_details" {
#     for_each = each.value.sap_type != null ? [each.value.sap_type] : []

#     content {
#       license_type = "byol"
#       product      = each.value.sap_type
#       vendor       = "SAP"
#     }
#   }
# }


resource "ibm_pi_image" "image_0" {
  count = length(var.pi_custom_images) > 0 ? 1 : 0

  pi_image_name             = var.pi_custom_images[0].image_name
  pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
  pi_image_bucket_name      = var.pi_custom_image_cos_configuration.bucket_name
  pi_image_bucket_access    = var.pi_custom_image_cos_configuration.bucket_access
  pi_image_bucket_region    = var.pi_custom_image_cos_configuration.bucket_region
  pi_image_bucket_file_name = var.pi_custom_images[0].file_name
  pi_image_storage_type     = var.pi_custom_images[0].storage_tier
  pi_image_access_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.cos_creds.cos_hmac_keys.access_key_id : null
  pi_image_secret_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.cos_creds.cos_hmac_keys.secret_access_key : null
  pi_user_tags              = var.pi_tags != null ? var.pi_tags : []

  dynamic "pi_image_import_details" {
    for_each = try(var.pi_custom_images[0].sap_type, null) != null ? [var.pi_custom_images[0].sap_type] : []

    content {
      license_type = "byol"
      product      = var.pi_custom_images[0].sap_type
      vendor       = "SAP"
    }
  }
}


resource "ibm_pi_image" "image_1" {
  count      = length(var.pi_custom_images) > 1 ? 1 : 0
  depends_on = [ibm_pi_image.image_0]

  pi_image_name             = var.pi_custom_images[1].image_name
  pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
  pi_image_bucket_name      = var.pi_custom_image_cos_configuration.bucket_name
  pi_image_bucket_access    = var.pi_custom_image_cos_configuration.bucket_access
  pi_image_bucket_region    = var.pi_custom_image_cos_configuration.bucket_region
  pi_image_bucket_file_name = var.pi_custom_images[1].file_name
  pi_image_storage_type     = var.pi_custom_images[1].storage_tier
  pi_image_access_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.cos_creds.cos_hmac_keys.access_key_id : null
  pi_image_secret_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.cos_creds.cos_hmac_keys.secret_access_key : null
  pi_user_tags              = var.pi_tags != null ? var.pi_tags : []

  dynamic "pi_image_import_details" {
    for_each = try(var.pi_custom_images[1].sap_type, null) != null ? [var.pi_custom_images[1].sap_type] : []

    content {
      license_type = "byol"
      product      = var.pi_custom_images[1].sap_type
      vendor       = "SAP"
    }
  }
}


resource "ibm_pi_image" "image_2" {
  count      = length(var.pi_custom_images) > 2 ? 1 : 0
  depends_on = [ibm_pi_image.image_1]

  pi_image_name             = var.pi_custom_images[count.index + 2].image_name
  pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
  pi_image_bucket_name      = var.pi_custom_image_cos_configuration.bucket_name
  pi_image_bucket_access    = var.pi_custom_image_cos_configuration.bucket_access
  pi_image_bucket_region    = var.pi_custom_image_cos_configuration.bucket_region
  pi_image_bucket_file_name = var.pi_custom_images[count.index + 2].file_name
  pi_image_storage_type     = var.pi_custom_images[count.index + 2].storage_tier
  pi_image_access_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.cos_creds.cos_hmac_keys.access_key_id : null
  pi_image_secret_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.cos_creds.cos_hmac_keys.secret_access_key : null
  pi_user_tags              = var.pi_tags != null ? var.pi_tags : []

  dynamic "pi_image_import_details" {
    # make pi_image_import_details optional
    for_each = try(var.pi_custom_images[count.index + 2].sap_type, null) != null ? [var.pi_custom_images[count.index + 2].sap_type] : []

    content {
      license_type = "byol"
      product      = var.pi_custom_images[count.index + 2].sap_type
      vendor       = "SAP"
    }
  }
}

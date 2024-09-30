#####################################################
# Import Catalog Stock Images
#####################################################

data "ibm_pi_catalog_images" "catalog_images_ds" {
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  sap                  = true
}

locals {
  catalog_images = {
    for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images :
    stock_image.name => stock_image.image_id
  }
}

resource "ibm_pi_image" "import_images" {
  for_each             = toset(var.pi_image_names)
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_image_id          = lookup(local.catalog_images, each.key, null)
  pi_image_name        = each.key

  timeouts {
    create = "9m"
  }
}


#####################################################
# Import Custom Image from COS
#####################################################

locals {
  custom_pi_image_cos_service_credentials = var.custom_pi_image_cos_configuration.bucket_access == "private" ? jsondecode(var.custom_pi_image_cos_service_credentials) : null
}

resource "ibm_pi_image" "custom_images" {
  for_each = { for image in var.custom_pi_images : image.image_name => image }

  pi_image_name             = each.key
  pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
  pi_image_bucket_name      = var.custom_pi_image_cos_configuration.bucket_name
  pi_image_bucket_access    = var.custom_pi_image_cos_configuration.bucket_access
  pi_image_bucket_region    = var.custom_pi_image_cos_configuration.bucket_region
  pi_image_bucket_file_name = each.value.file_name
  pi_image_storage_type     = each.value.storage_tier
  pi_image_access_key       = var.custom_pi_image_cos_configuration.bucket_access == "private" ? local.custom_pi_image_cos_service_credentials.cos_hmac_keys.access_key_id : null
  pi_image_secret_key       = var.custom_pi_image_cos_configuration.bucket_access == "private" ? local.custom_pi_image_cos_service_credentials.cos_hmac_keys.secret_access_key : null

  dynamic "pi_image_import_details" {
    # make pi_image_import_details optional
    for_each = each.value.sap_type != null ? [each.value.sap_type] : []

    content {
      license_type = "byol"
      product      = each.value.sap_type
      vendor       = "SAP"
    }
  }
}


################
# For output
################

locals {
  pi_images = merge({ for image in ibm_pi_image.import_images : image.pi_image_name => image.image_id }, { for image in ibm_pi_image.custom_images : image.pi_image_name => image.image_id })
}

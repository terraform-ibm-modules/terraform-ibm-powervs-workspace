#####################################################
# Import Catalog Stock Images
#####################################################

data "ibm_pi_catalog_images" "catalog_images_ds" {
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  sap                  = true
  provider             = ibm
}

locals {
  catalog_images = {
    for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images :
    stock_image.name => stock_image.image_id
    if stock_image.name == [for img in data.ibm_pi_catalog_images.catalog_images_ds.images : img.name][0]
  }
}

resource "ibm_pi_image" "import_images" {
  for_each             = toset(var.pi_image_names)
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  #pi_image_id          = lookup(local.catalog_images, each.key, null)
  pi_image_id   = "e0ea7bb6-8512-4ec4-a2ba-48e5adab3fa9"
  pi_image_name = each.key
  # pi_image_bucket_name = "None"
  # pi_image_bucket_file_name = "None"
  # pi_image_bucket_region = "None"
  #pi_ostype = "ibmi"
  pi_user_tags = var.pi_tags != null ? var.pi_tags : []
  provider     = ibm

  timeouts {
    create = "9m"
  }
}


#####################################################
# Import Custom Image from COS
#####################################################

locals {
  pi_custom_image_cos_service_credentials = var.pi_custom_image_cos_configuration != null ? var.pi_custom_image_cos_configuration.bucket_access == "private" ? jsondecode(var.pi_custom_image_cos_service_credentials) : null : null
}

resource "ibm_pi_image" "pi_custom_image1" {
  count = var.pi_custom_image1 != null ? 1 : 0

  pi_image_name             = var.pi_custom_image1.image_name
  pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
  pi_image_bucket_name      = var.pi_custom_image_cos_configuration.bucket_name
  pi_image_bucket_access    = var.pi_custom_image_cos_configuration.bucket_access
  pi_image_bucket_region    = var.pi_custom_image_cos_configuration.bucket_region
  pi_image_bucket_file_name = var.pi_custom_image1.file_name
  pi_image_storage_type     = var.pi_custom_image1.storage_tier
  pi_image_access_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.pi_custom_image_cos_service_credentials.cos_hmac_keys.access_key_id : null
  pi_image_secret_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.pi_custom_image_cos_service_credentials.cos_hmac_keys.secret_access_key : null
  pi_user_tags              = var.pi_tags != null ? var.pi_tags : []

  dynamic "pi_image_import_details" {
    # make pi_image_import_details optional
    for_each = var.pi_custom_image1.sap_type != null ? [var.pi_custom_image1.sap_type] : []

    content {
      license_type = "byol"
      product      = var.pi_custom_image1.sap_type
      vendor       = "SAP"
    }
  }
}

resource "ibm_pi_image" "pi_custom_image2" {
  count      = var.pi_custom_image2 != null ? 1 : 0
  depends_on = [ibm_pi_image.pi_custom_image1]

  pi_image_name             = var.pi_custom_image2.image_name
  pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
  pi_image_bucket_name      = var.pi_custom_image_cos_configuration.bucket_name
  pi_image_bucket_access    = var.pi_custom_image_cos_configuration.bucket_access
  pi_image_bucket_region    = var.pi_custom_image_cos_configuration.bucket_region
  pi_image_bucket_file_name = var.pi_custom_image2.file_name
  pi_image_storage_type     = var.pi_custom_image2.storage_tier
  pi_image_access_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.pi_custom_image_cos_service_credentials.cos_hmac_keys.access_key_id : null
  pi_image_secret_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.pi_custom_image_cos_service_credentials.cos_hmac_keys.secret_access_key : null
  pi_user_tags              = var.pi_tags != null ? var.pi_tags : []

  dynamic "pi_image_import_details" {
    # make pi_image_import_details optional
    for_each = var.pi_custom_image2.sap_type != null ? [var.pi_custom_image2.sap_type] : []

    content {
      license_type = "byol"
      product      = var.pi_custom_image2.sap_type
      vendor       = "SAP"
    }
  }
}

resource "ibm_pi_image" "pi_custom_image3" {
  count      = var.pi_custom_image3 != null ? 1 : 0
  depends_on = [ibm_pi_image.pi_custom_image1, ibm_pi_image.pi_custom_image2]

  pi_image_name             = var.pi_custom_image3.image_name
  pi_cloud_instance_id      = ibm_resource_instance.pi_workspace.guid
  pi_image_bucket_name      = var.pi_custom_image_cos_configuration.bucket_name
  pi_image_bucket_access    = var.pi_custom_image_cos_configuration.bucket_access
  pi_image_bucket_region    = var.pi_custom_image_cos_configuration.bucket_region
  pi_image_bucket_file_name = var.pi_custom_image3.file_name
  pi_image_storage_type     = var.pi_custom_image3.storage_tier
  pi_image_access_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.pi_custom_image_cos_service_credentials.cos_hmac_keys.access_key_id : null
  pi_image_secret_key       = var.pi_custom_image_cos_configuration.bucket_access == "private" ? local.pi_custom_image_cos_service_credentials.cos_hmac_keys.secret_access_key : null
  pi_user_tags              = var.pi_tags != null ? var.pi_tags : []

  dynamic "pi_image_import_details" {
    # make pi_image_import_details optional
    for_each = var.pi_custom_image3.sap_type != null ? [var.pi_custom_image3.sap_type] : []

    content {
      license_type = "byol"
      product      = var.pi_custom_image3.sap_type
      vendor       = "SAP"
    }
  }
}

################
# For output
################

locals {
  pi_images = merge({ for image in ibm_pi_image.import_images : image.pi_image_name => image.image_id }, { for image in ibm_pi_image.pi_custom_image1 : image.pi_image_name => image.image_id }, { for image in ibm_pi_image.pi_custom_image2 : image.pi_image_name => image.image_id }, { for image in ibm_pi_image.pi_custom_image3 : image.pi_image_name => image.image_id })
}

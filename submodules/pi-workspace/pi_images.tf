#####################################################
# Import Catalog Images
#####################################################

data "ibm_pi_catalog_images" "catalog_images_ds" {
  sap                  = true
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
}

locals {

  split_images_list = var.pi_image_names != null ? chunklist(var.pi_image_names, 2) : []
  images_count      = length(local.split_images_list)

  split_images_1 = (local.images_count > 0 ? toset(element(local.split_images_list, local.images_count - length(local.split_images_list))) : [])
  split_images_2 = (length(local.split_images_1) > 0 && (local.images_count - 1) > 0 ? toset(element(local.split_images_list, (local.images_count - length(local.split_images_list)) + 1)) : [])
  split_images_3 = (length(local.split_images_2) > 0 && (local.images_count - 2) > 0 ? toset(element(local.split_images_list, (local.images_count - length(local.split_images_list)) + 2)) : [])

  catalog_images_to_import_1 = flatten([for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images : [for image_name in local.split_images_1 : stock_image if stock_image.name == image_name]])
  catalog_images_to_import_2 = flatten([for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images : [for image_name in local.split_images_2 : stock_image if stock_image.name == image_name]])
  catalog_images_to_import_3 = flatten([for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images : [for image_name in local.split_images_3 : stock_image if stock_image.name == image_name]])

}


#######################################################
# Using 3 resource blocks for import images as parallel
# import of multiple images causes an error
#######################################################

resource "ibm_pi_image" "import_images_1" {

  for_each             = toset(local.split_images_1)
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_image_id          = local.catalog_images_to_import_1[index(tolist(local.split_images_1), each.key)].image_id
  pi_image_name        = each.key

  timeouts {
    create = "9m"
  }
}

resource "ibm_pi_image" "import_images_2" {
  depends_on           = [ibm_pi_image.import_images_1]
  for_each             = toset(local.split_images_2)
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_image_id          = local.catalog_images_to_import_2[index(tolist(local.split_images_2), each.key)].image_id
  pi_image_name        = each.key

  timeouts {
    create = "9m"
  }
}

resource "ibm_pi_image" "import_images_3" {
  depends_on           = [ibm_pi_image.import_images_2]
  for_each             = toset(local.split_images_3)
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_image_id          = local.catalog_images_to_import_3[index(tolist(local.split_images_3), each.key)].image_id
  pi_image_name        = each.key

  timeouts {
    create = "9m"
  }
}

################
# For output
################

locals {
  import_images_1 = length(local.split_images_1) >= 1 ? { for image in ibm_pi_image.import_images_1 : image.pi_image_name => image.image_id } : null
  import_images_2 = length(local.split_images_2) >= 1 ? { for image in ibm_pi_image.import_images_2 : image.pi_image_name => image.image_id } : null
  import_images_3 = length(local.split_images_3) >= 1 ? { for image in ibm_pi_image.import_images_3 : image.pi_image_name => image.image_id } : null
  pi_images       = merge(local.import_images_1, local.import_images_2, local.import_images_3)
}

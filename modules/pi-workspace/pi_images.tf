#####################################################
# Import Catalog Images
#####################################################

data "ibm_pi_catalog_images" "catalog_images_ds" {
  sap                  = true
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
}

locals {
  catalog_images_to_import = flatten([for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images : [for image_name in var.pi_image_names : stock_image if stock_image.name == image_name]])
}

#######################################################
# Import of multiple images
#######################################################

resource "ibm_pi_image" "import_images" {

  for_each             = toset(var.pi_image_names)
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_image_id          = local.catalog_images_to_import[index((var.pi_image_names), each.key)].image_id
  pi_image_name        = each.key

  timeouts {
    create = "9m"
  }
}


################
# For output
################

locals {

  pi_images = { for image in ibm_pi_image.import_images : image.pi_image_name => image.image_id }
}

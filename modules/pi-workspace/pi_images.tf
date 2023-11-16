#####################################################
# Import Catalog Images
#####################################################

data "ibm_pi_catalog_images" "catalog_images_ds" {
  sap                  = true
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
}

locals {
  catalog_images = { for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images : stock_image.name => stock_image.image_id }
}

#######################################################
# Import of multiple images
#######################################################

resource "ibm_pi_image" "import_images" {

  for_each             = toset(var.pi_image_names)
  pi_cloud_instance_id = ibm_resource_instance.pi_workspace.guid
  pi_image_id          = lookup(local.catalog_images, each.key, null)
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

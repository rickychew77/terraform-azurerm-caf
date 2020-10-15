resource "azurecaf_name" "sig1" {
  name          = var.settings.galleries.name
  prefixes      = [var.global_settings.prefix]
  resource_type = "azurerm_shared_image_gallery"
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
}

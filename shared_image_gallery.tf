module shared_image_gallery {
  source              = "./modules/shared_image_gallery"
  for_each            = local.shared_services.shared_image_gallery
  global_settings     = local.global_settings
  settings            = each.value
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
}
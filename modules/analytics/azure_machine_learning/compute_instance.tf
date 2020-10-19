module compute_instance {
  source   = "./compute_instance"
  for_each = try(var.settings.compute_instances, {})

  global_settings                 = var.global_settings
  settings                        = each.value
  resource_group_name             = azurerm_machine_learning_workspace.ws.resource_group_name
  location                        = azurerm_machine_learning_workspace.ws.location
  machine_learning_workspace_name = azurerm_machine_learning_workspace.ws.name
  subnet_id                       = var.subnets[each.value.subnet_key].id
}

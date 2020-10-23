# module azurerm_network_security_group {
#   source = "../virtual_network/nsg"

#   resource_group                    = var.resource_group_name
#   tags                              = local.tags
#   location                          = var.location

#   subnets                           = var.settings.nsg.subnets
#   network_security_group_definition = var.network_security_group_definition
#   diagnostics                       = var.diagnostics
#   global_settings                   = var.global_settings
# }

resource "azurecaf_name" "nsg_obj" {
  for_each      = var.settings.nsg
  name          = each.value.name
  resource_type = "azurerm_network_security_group"
  prefixes      = [var.global_settings.prefix]
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
}

resource "azurerm_network_security_group" "nsg" {

  for_each            = var.settings.nsg
  name                = azurecaf_name.nsg_obj[each.key].result
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  dynamic "security_rule" {
    for_each = lookup(each.value, "nsg_name", null) == null ? [] : each.network_security_group_definition
    content {
      name                                       = lookup(security_rule.value, "name", null)
      priority                                   = lookup(security_rule.value, "priority", null)
      direction                                  = lookup(security_rule.value, "direction", null)
      access                                     = lookup(security_rule.value, "access", null)
      protocol                                   = lookup(security_rule.value, "protocol", null)
      source_port_range                          = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges                         = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range                     = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges                    = lookup(security_rule.value, "destination_port_ranges", null)
      source_address_prefix                      = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes                    = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix                 = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes               = lookup(security_rule.value, "destination_address_prefixes", null)
      source_application_security_group_ids      = lookup(security_rule.value, "source_application_security_group_ids ", null)
      destination_application_security_group_ids = lookup(security_rule.value, "destination_application_security_group_ids ", null)
    }
  }

}

resource "azurerm_subnet_network_security_group_association" "nsg_vnet_association" {
  for_each = module.subnets

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

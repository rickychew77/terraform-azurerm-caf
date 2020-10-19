resource "null_resource" "packer-exec1" {
  count = var.settings.use_marketplace_image ? 1 : 0
  provisioner "local-exec" {
    command = "packer.io build packer-exec1.pkr.hcl"
}


resource "null_resource" "packer-exec2" {
  count = var.settings.use_managed_image ? 1 : 0
  provisioner "local-exec" {
    command = "packer.io build packer-exec2.pkr.hcl
}


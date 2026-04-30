data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

resource "vsphere_folder" "vm_folder" {
  path          = var.name
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

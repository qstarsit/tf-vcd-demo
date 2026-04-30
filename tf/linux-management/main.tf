# Folder to organize the VM's

module "vm_folder" {
  name   = var.vsphere_folder
  source = "../modules/vm_folder"
}

# Stepstone server

module "ubu-step-01" {
  source = "../modules/vm_clone"

  name                 = "ubu-step-01"
  cpu_cores            = 2
  cpu_cores_per_socket = 2
  memory               = 4096
  ip_address           = "10.56.15.111"
  ip_netmask           = 24
  ip_gateway           = "10.56.15.254"
  notes                = "Ubuntu stepstone server"
  datadisk_size        = 10

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-04"
  vsphere_network   = "VLAN 15 MANAGEMENT"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

# Rancher cluster (single-node)

module "ubu-ran-01" {
  source = "../modules/vm_clone"

  name                 = "ubu-ran-01"
  cpu_cores            = 4
  cpu_cores_per_socket = 2
  memory               = 16384
  ip_address           = "10.56.15.112"
  ip_netmask           = 24
  ip_gateway           = "10.56.15.254"
  notes                = "Rancher cluster (single-node)"
  datadisk_size        = 100

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-05"
  vsphere_network   = "VLAN 15 MANAGEMENT"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

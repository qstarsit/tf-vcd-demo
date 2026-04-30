# Folder to organize the VM's

module "vm_folder" {
  name   = var.vsphere_folder
  source = "../modules/vm_folder"
}

# DMZ haproxy server

module "ubu-haproxy-01" {
  source = "../modules/vm_clone"

  name                 = "ubu-haproxy-01"
  cpu_cores            = 2
  cpu_cores_per_socket = 2
  memory               = 4096
  ip_address           = "10.10.0.220"
  ip_netmask           = 24
  ip_gateway           = "10.10.0.254"
  notes                = "Ubuntu HAproxy01"
  datadisk_size        = 10

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-02"
  vsphere_network   = "VLAN 110 DMZ"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

module "ubu-haproxy-02" {
  source = "../modules/vm_clone"

  name                 = "ubu-haproxy-02"
  cpu_cores            = 2
  cpu_cores_per_socket = 2
  memory               = 4096
  ip_address           = "10.10.0.221"
  ip_netmask           = 24
  ip_gateway           = "10.10.0.254"
  notes                = "Ubuntu HAproxy02"
  datadisk_size        = 10

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-02"
  vsphere_network   = "VLAN 110 DMZ"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}
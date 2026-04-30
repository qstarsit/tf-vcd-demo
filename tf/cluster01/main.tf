# Folder to organize the VM's

module "vm_folder" {
  name   = var.vsphere_folder
  source = "../modules/vm_folder"
}

# Cluster 01 - Controlplanes

module "ubu-cl01-01" {
  source = "../modules/vm_clone"

  name                 = "ubu-cl01-01"
  cpu_cores            = 2
  cpu_cores_per_socket = 2
  memory               = 4096
  ip_address           = "10.56.14.31"
  ip_netmask           = 24
  ip_gateway           = "10.56.14.254"
  notes                = "Ubuntu - Cluster 01 - Controlplane 1"
  datadisk_size        = 100

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-01"
  vsphere_network   = "VLAN 14 SERVERS"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

module "ubu-cl01-02" {
  source = "../modules/vm_clone"

  name                 = "ubu-cl01-02"
  cpu_cores            = 2
  cpu_cores_per_socket = 2
  memory               = 4096
  ip_address           = "10.56.14.32"
  ip_netmask           = 24
  ip_gateway           = "10.56.14.254"
  notes                = "Ubuntu - Cluster 01 - Controlplane 2"
  datadisk_size        = 100

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-02"
  vsphere_network   = "VLAN 14 SERVERS"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

module "ubu-cl01-03" {
  source = "../modules/vm_clone"

  name                 = "ubu-cl01-03"
  cpu_cores            = 2
  cpu_cores_per_socket = 2
  memory               = 4096
  ip_address           = "10.56.14.33"
  ip_netmask           = 24
  ip_gateway           = "10.56.14.254"
  notes                = "Ubuntu - Cluster 01 - Controlplane 3"
  datadisk_size        = 100

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-03"
  vsphere_network   = "VLAN 14 SERVERS"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

# Cluster 01 - Workers

module "ubu-cl01-04" {
  source = "../modules/vm_clone"

  name                 = "ubu-cl01-04"
  cpu_cores            = 6
  cpu_cores_per_socket = 2
  memory               = 16384
  ip_address           = "10.56.14.34"
  ip_netmask           = 24
  ip_gateway           = "10.56.14.254"
  notes                = "Ubuntu - Cluster 01 - Worker 1"
  datadisk_size        = 100

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-04"
  vsphere_network   = "VLAN 14 SERVERS"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

module "ubu-cl01-05" {
  source = "../modules/vm_clone"

  name                 = "ubu-cl01-05"
  cpu_cores            = 6
  cpu_cores_per_socket = 2
  memory               = 16384
  ip_address           = "10.56.14.35"
  ip_netmask           = 24
  ip_gateway           = "10.56.14.254"
  notes                = "Ubuntu - Cluster 01 - Worker 2"
  datadisk_size        = 100

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-05"
  vsphere_network   = "VLAN 14 SERVERS"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

module "ubu-cl01-06" {
  source = "../modules/vm_clone"

  name                 = "ubu-cl01-06"
  cpu_cores            = 6
  cpu_cores_per_socket = 2
  memory               = 16384
  ip_address           = "10.56.14.36"
  ip_netmask           = 24
  ip_gateway           = "10.56.14.254"
  notes                = "Ubuntu - Cluster 01 - Worker 3"
  datadisk_size        = 100

  vsphere_cluster   = "cluster1"
  vsphere_datastore = "DC1-VMFS-06"
  vsphere_network   = "VLAN 14 SERVERS"
  vsphere_folder    = var.vsphere_folder
  vm_template       = "ubu-img-01"

  depends_on = [
    module.vm_folder
  ]
}

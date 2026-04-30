data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name                 = var.name
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  folder               = var.vsphere_folder
  num_cpus             = var.cpu_cores
  num_cores_per_socket = var.cpu_cores_per_socket
  memory               = var.memory
  guest_id             = data.vsphere_virtual_machine.template.guest_id
  scsi_type            = data.vsphere_virtual_machine.template.scsi_type
  annotation           = "IMPORTANT NOTICE: This server is managed by Terraform.\ndo NOT edit manually!\n---\n${var.notes}"
  firmware             = "efi"

  # Network interface
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  # First disk, the "rootdisk", which is used for the operating system
  disk {
    label            = "disk0"
    size             = var.rootdisk_size
    unit_number      = 0
    thin_provisioned = false
    eagerly_scrub    = false
  }

  # Second disk, the "datadisk", used for data storage
  disk {
    label            = "disk1"
    size             = var.datadisk_size
    unit_number      = 1
    thin_provisioned = false
    eagerly_scrub    = false
  }

  # Clone the template
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.name
        domain    = var.dns_domain
      }
      network_interface {
        ipv4_address    = var.ip_address
        ipv4_netmask    = var.ip_netmask
        dns_domain      = var.dns_domain
        dns_server_list = var.dns_server
      }
      ipv4_gateway = var.ip_gateway
    }
  }

  # This prevents servers being recreated due to changes in the template
  lifecycle {
    ignore_changes = [
      clone[0].template_uuid
    ]
  }
}

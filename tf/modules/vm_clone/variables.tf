variable "name" {
  type        = string
  description = "Name for the instance"
}

variable "vm_template" {
  type        = string
  description = "Name of the VM template to deploy VM's"
  default     = "ubu-img-01"
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "cpu_cores_per_socket" {
  type        = number
  description = "Number of CPU cores per socket"
  default     = 2
}

variable "memory" {
  type        = number
  description = "Amount of memory in the instance"
  default     = 2048
}

variable "ip_address" {
  type        = string
  description = "IP address for the instance"
}

variable "ip_netmask" {
  type        = number
  description = "Netmask for the IP address of the instance"
}

variable "ip_gateway" {
  type        = string
  description = "IP gateway for the instance"
}

variable "dns_domain" {
  type        = string
  description = "DNS domain name"
  default     = "klant.local"
}

variable "dns_server" {
  type        = list(string)
  description = "DNS nameserver"
  default     = ["10.56.14.71", "10.56.14.72", "10.56.14.73"]
}

variable "notes" {
  type        = string
  description = "Notes for the given VM"
  default     = "Terraform managed"
}

variable "rootdisk_size" {
  type        = number
  description = "Size of rootdisk (first disk), in GB"
  default     = 50
}

variable "datadisk_size" {
  type        = number
  description = "Size of datadisk (second disk), in GB"
  default     = 100
}

variable "vsphere_datacenter" {
  type        = string
  description = "Name of the vSphere datacenter"
  default     = "DC1"
}

variable "vsphere_cluster" {
  type        = string
  description = "Name of the vSphere cluster"
}

variable "vsphere_network" {
  type        = string
  description = "Name of the vSphere network"
}

variable "vsphere_datastore" {
  type        = string
  description = "Name of the vSphere datastore to store the VM"
}

variable "vsphere_folder" {
  type        = string
  description = "Name of the vSphere folder to organise the VM"
}

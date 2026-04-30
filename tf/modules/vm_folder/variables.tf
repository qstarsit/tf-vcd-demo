variable "name" {
  type        = string
  description = "Name for the vm folder"
}

variable "vsphere_datacenter" {
  type        = string
  description = "Name of the vSphere datacenter"
  default     = "klant"
}


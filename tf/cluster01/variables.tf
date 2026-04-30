# VMware vCenter API credentials
# Copy terraform.tfvars.example to terraform.tfvars and update its values.

variable "vcenter_server" {
  type        = string
  description = "Hostname or IP-address of the vCenter server"
  default     = "vcenter.klant.local"
}

variable "vcenter_username" {
  type        = string
  description = "Username to login to vCenter"
}

variable "vcenter_password" {
  type        = string
  description = "Username to login to vCenter"
}

variable "gitlab_server" {
  type        = string
  description = "Hostname or IP-address of the GitLab server"
  default     = "gitlab.klant.local"
}

variable "gitlab_username" {
  type        = string
  description = "Username to login to GitLab"
}

variable "gitlab_token" {
  type        = string
  description = "Token to login to GitLab"
}

variable "vsphere_folder" {
  type        = string
  default     = "Linux/Cluster 01"
  description = "Folder to store the VMs in this configuration"
}

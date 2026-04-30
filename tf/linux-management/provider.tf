terraform {
  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "= 2.15.2"
    }
  }
  backend "http" {
    address                = "https://gitlab.klant.local/api/v4/projects/29/terraform/state/cluster01"
    lock_address           = "https://gitlab.klant.local/api/v4/projects/29/terraform/state/cluster01/lock"
    unlock_address         = "https://gitlab.klant.local/api/v4/projects/29/terraform/state/cluster01/lock"
    lock_method            = "POST"
    unlock_method          = "DELETE"
    retry_wait_min         = 5
    skip_cert_verification = true
    username               = var.gitlab_username
    password               = var.gitlab_token
  }
}

provider "vsphere" {
  user                 = var.vcenter_username
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_server
  allow_unverified_ssl = true
}


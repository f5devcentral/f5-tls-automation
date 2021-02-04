provider "bigip" {
  address  = "https://${var.bigip_mgmt_ip}"
  username = var.bigip_user
  password = var.bigip_password
}

terraform {
  required_providers {
    bigip = {
      source  = "f5networks/bigip"
      version = "~> 1.5"
    }
  }
}

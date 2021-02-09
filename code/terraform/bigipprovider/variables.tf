
#variable for BIG-IP
variable "bigip_user" {}
variable "bigip_password" {
  sensitive = true
}
variable "bigip_mgmt_ip" {}

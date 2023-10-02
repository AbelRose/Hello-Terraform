#定义云厂商
provider "alicloud" {
  region     = var.region
  access_key = var.alicloud_access_key
  secret_key = var.alicloud_secret_key
}
resource "alicloud_vpc" "vpc" {
  vpc_name   = "vpc_1"
  cidr_block = var.vpc_cidr
  
}

resource "alicloud_vswitch" "vsw_1" {
  vswitch_name = "vsw_aliyun1"
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_cidr
  zone_id      = "cn-shanghai-b"
}
resource "alicloud_vpc" "vpc" {
  vpc_name   = "kevin-vpc"
  cidr_block = "10.0.0.0/16"
}

#定义云厂商
provider "alicloud" {
  region     = var.REGION
  access_key = var.ALICLOUD_ACCESS_KEY
  secret_key = var.ALICLOUD_SECRET_KEY
}

#创建vpc
resource "alicloud_vpc" "vpc" {
  vpc_name   = "vpc_1"
  cidr_block = "10.0.0.0/16"
}

# 创建vswitch
resource "alicloud_vswitch" "vsw_1" {
  vswitch_name = "vsw_aliyun1"
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.0.0/24"
  zone_id      = "cn-shanghai-b"
}

#新建安全组
resource "alicloud_security_group" "nsg1" {
  name   = "lyc_aliyun_nsg1"
  vpc_id = alicloud_vpc.vpc.id
}

#将nsg_rule1、nsg_rule2加入安全组lyc_aliyun_nsg1中
resource "alicloud_security_group_rule" "nsg_rule1" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.nsg1.id
  cidr_ip           = "0.0.0.0/0"
}

#创建ECS实例
resource "alicloud_instance" "instance" {
  # cn-shanghai
  availability_zone          = "cn-shanghai-b"
  security_groups            = ["${alicloud_security_group.nsg1.id}"]
  instance_type              = "ecs.n1.small"
  system_disk_category       = "cloud_ssd"
  image_id                   = "centos_7_9_x64_20G_alibase_20220824.vhd"
  instance_name              = "lyc-kevin2"
  vswitch_id                 = alicloud_vswitch.vsw_1.id
  internet_max_bandwidth_out = 5
  password                   = "5jejYWzSjZhWQc7G22"
}

resource "alicloud_oss_bucket" "ossbucket1" {
  bucket = "ossbucket1-kevin-aptx4869-ikun1"
  acl    = "private"
  # depends_on 表示必须创建完 instance 之后才能创建 ossbucket1
  depends_on = [
    alicloud_instance.instance
  ]
}

resource "alicloud_oss_bucket" "ossbucket2" {
  bucket = "ossbucket1-kevin-aptx4869-niganma2"
  acl    = "private"
  depends_on = [
    alicloud_oss_bucket.ossbucket1
  ]
}

resource "alicloud_oss_bucket" "ossbucket3" {
  bucket = "ossbucket1-kevin-aptx4869-zhiyinnitaimei3"
  acl    = "private"
  depends_on = [
    alicloud_oss_bucket.ossbucket2
  ]
}
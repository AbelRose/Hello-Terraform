resource "alicloud_vswitch" "vsw_1" {
  vswitch_name = "vsw_aliyun1"
  # vswitch 引用 vpc中的内容
  # 1. 先定义 创建一个 variable.tf 的文件
  # 2. 直接引用 variable.tf 中的变量 会从 variable.tf 读到
  vpc_id       = var.vpc_id
  cidr_block   = "10.0.0.0/24"
  zone_id      = "cn-shanghai-b"
}
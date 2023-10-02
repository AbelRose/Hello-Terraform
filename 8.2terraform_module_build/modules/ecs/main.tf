#创建ECS实例
resource "alicloud_instance" "instance" {
  availability_zone          = "cn-shanghai-b"
  instance_type              = "ecs.n1.small"
  system_disk_category       = "cloud_ssd"
  image_id                   = "centos_7_9_x64_20G_alibase_20220824.vhd"
  instance_name              = "lyc-kevin2"
  internet_max_bandwidth_out = 5
  password                   = "5jejYWzSjZhWQc7G22"
  # 同一级的文件夹用var来引用
  security_groups            = ["${var.security_groups}"]
  vswitch_id                 = var.vswitch_id
}
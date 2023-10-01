# 控制台输出log
### 可以放在同一个文件中 也可以放在跟主文件相同目录的文件中 可以在不同模块间进行调用 ###
# output instance_pub_ip {
#   value       = alicloud_instance.instance1.public_ip
#   description = "This is instance_pub_ip"
# }

output "name_reg_matrix" {
  # value = data.alicloud_instances.instance-matrix.instances.id
  # 列表的话 要带上 *
  # value = data.alicloud_instances.instance-matrix.instances.*.id
  value = data.alicloud_instances.instance-matrix.instances.*.name
}
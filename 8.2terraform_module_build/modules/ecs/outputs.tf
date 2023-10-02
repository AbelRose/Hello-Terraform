output "ecs_pub_ip" {
  value       = alicloud_instance.instance.public_ip
  description = "ecs_pub_ip"
}

output "ecs_id" {
  value       = alicloud_instance.instance.id
  description = "ecs_id"
}

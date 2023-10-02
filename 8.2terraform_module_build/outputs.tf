# 只有根目录的才是输出的到控制台
output "ecs_pub_ip" {
  value = module.ecs.ecs_pub_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_id" {
  value = module.ecs.ecs_id
}
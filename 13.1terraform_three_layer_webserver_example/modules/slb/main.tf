
#创建负载均衡器
resource "alicloud_slb_load_balancer" "slb" {
  load_balancer_name = var.load_balancer_name
  address_type       = var.address_type
  load_balancer_spec = var.load_balancer_spec
}

#创建默认服务器组
resource "alicloud_slb_backend_server" "default" {
  load_balancer_id = alicloud_slb_load_balancer.slb.id

  backend_servers {
    server_id = var.server_id1
    weight    = 100
  }
  backend_servers {
    server_id = var.server_id2
    weight    = 100
  }
}

#添加监听
resource "alicloud_slb_listener" "slb_listener" {
  load_balancer_id = alicloud_slb_load_balancer.slb.id
  backend_port     = 80
  frontend_port    = 80
  protocol         = "http"
  #   bandwidth                 = 10
  #   sticky_session            = "on"
  #   sticky_session_type       = "insert"
  #   cookie_timeout            = 86400
  #   cookie                    = "testslblistenercookie"
  #   health_check              = "on"
  #   # health_check_domain       = "ali.com"
  #   # health_check_uri          = "/cons"
  #   health_check_connect_port = 20
  #   healthy_threshold         = 8
  #   unhealthy_threshold       = 8
  #   health_check_timeout      = 8
  #   health_check_interval     = 5
  #   health_check_http_code    = "http_2xx,http_3xx"
  #   x_forwarded_for {
  #     retrive_slb_ip = true
  #     retrive_slb_id = true
  #   }
  #   acl_status      = "on"
  #   acl_type        = "white"
  #   # acl_id          = alicloud_slb_acl.default.id
  #   # request_timeout = 80
  #   # idle_timeout    = 30
}

#使用模块，这里不建议使用，删除
# module "slb" {
#   source  = "alibaba/slb/alicloud"
#   name = "TFSLB"
#   servers_of_default_server_group = [
#     {
#       # server_ids = "i-bp1xxxxxxxxxx1,i-bp1xxxxxxxxxx2"
#       server_ids = "${module.ecs[0].this_instance_id[0]},${module.ecs[1].this_instance_id[0]}"
#       weight     = "100"
#       type       = "ecs"
#     }
#   ]
# }

# resource "alicloud_slb_acl" "default" {
#   name       = "slb_acl"
#   ip_version = "ipv4"
#   entry_list {
#     entry   = "10.10.10.0/24"
#     comment = "first"
#   }
#   entry_list {
#     entry   = "168.10.10.0/24"
#     comment = "second"
#   }
# }



#创建虚拟服务器组
# resource "alicloud_slb_server_group" "server_group" {
#   load_balancer_id = alicloud_slb_load_balancer.slb.id
#   name             = "server_group"
#   servers {
#     # server_ids = [module.ecs[0].id, module.ecs[1].id]

#     # server_ids = "${module.ecs[0].this_instance_id[0]},${module.ecs[1].this_instance_id[0]}"
#     server_ids = ["${module.ecs[0].this_instance_id[0]}","${module.ecs[1].this_instance_id[0]}"]
#     port       = 80
#     weight     = 100
#   }
#   # servers {
#   #   server_ids = alicloud_instance.instance.*.id
#   #   port       = 80
#   #   weight     = 100
#   # }
# }

# #attach虚拟服务器组
# resource "alicloud_slb_server_group_server_attachment" "slb_server_attach" {
#   # count           = var.num
#   server_group_id = alicloud_slb_server_group.server_group.id
#   # server_id       = alicloud_instance.default[count.index].id
#   server_id = "${module.ecs[0].this_instance_id[0]}"
#   port            = 80
#   weight          = 100
# }

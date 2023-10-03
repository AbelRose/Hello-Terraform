#负载均衡器实例
resource "alicloud_slb_load_balancer" "slb" {
  load_balancer_name = var.load_balancer_name
  address_type       = var.address_type
  load_balancer_spec = var.load_balancer_spec
}

#创建后端默认服务器组
resource "alicloud_slb_backend_server" "backend_server" {
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

#添加实例的前端监听
resource "alicloud_slb_listener" "listener" {
  load_balancer_id = alicloud_slb_load_balancer.slb.id
  backend_port     = 80 # 前端的80
  frontend_port    = 80 # 后端的80
  protocol         = "http"
}

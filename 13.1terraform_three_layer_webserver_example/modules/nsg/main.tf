resource "alicloud_security_group" "nsg" {
  name   = "lyc_aliyun_nsg1"
  vpc_id = var.vpc_id
}

resource "alicloud_security_group_rule" "nsg_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.nsg.id
  cidr_ip           = "0.0.0.0/0"
}

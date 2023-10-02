#新建安全组
resource "alicloud_security_group" "nsg1" {
  name   = "lyc_aliyun_nsg1"
  vpc_id = var.vpc_id
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
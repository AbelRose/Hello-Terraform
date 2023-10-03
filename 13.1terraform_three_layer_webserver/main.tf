# 云上的模块
module "vpc" {
  source   = "alibaba/vpc/alicloud"
  create   = true
  vpc_name = "three_layer_webserver_vpc"
  # VPC网段为10.0.0.0/16
  vpc_cidr = "10.0.0.0/16"
  # 分别在上海可用区l与m中
  availability_zones = ["cn-shanghai-l", "cn-shanghai-m"]
  # VSwithc网段为10.0.0.0/24、10.0.1.0/24
  vswitch_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]
  vpc_tags = {
    Owner       = "kevin"
    Environment = "product"
  }
  vswitch_tags = {
    Project     = "kevin"
    Environment = "product"
  }
}

# 自己创建的模块
module "nsg" {
  source = "./modules/nsg"
  vpc_id = module.vpc.this_vpc_id
}

# 云上的模块
module "ecs" {
  source = "alibaba/ecs-instance/alicloud"
  # number_of_instances = 2 # 默认是1
  count = 2 # 实例的数量和${}index取值(从0开始)
  # ECS的备注名及主机名为web-1，web-2
  name = "web-${count.index + 1}"
  # 在Terraform配置这里
  image_id                    = "centos_7_9_x64_20G_alibase_20220824.vhd"
  instance_type               = "ecs.c7.large"
  vswitch_id                  = module.vpc.this_vswitch_ids[count.index] # count.index 动态获取的 第一个是0 第二个是1
  security_group_ids          = [module.nsg.nsg_id]
  associate_public_ip_address = true
  internet_max_bandwidth_out  = 10
  password                    = "5jejYWzSjZhWQc7G22"
  system_disk_category        = "cloud_essd"
  system_disk_size            = 50
  # ECS的备注名及主机名为web-1，web-2
  host_name = "web-${count.index + 1}"
  # 附加数据盘 服务器需要购买两块数据盘并设置开机自动挂载数据盘到/dataB和/dataC路径下。
  data_disks = [
    {
      name     = "data_diskB"
      category = "cloud_essd"
      size     = "20"
    },
    {
      name     = "data_diskC"
      category = "cloud_essd"
      size     = "40"
    }
  ]
  # 机器的一些初始化操作
  # 服务器需要购买两块数据盘并设置开机自动挂载数据盘到/dataB和/dataC路径下。 机器需要安装nginx并将内网ip写入nginx的欢迎界面，并验证。
  user_data = local.user_data
}

module "slb" {
  source             = "./modules/slb"
  load_balancer_name = "web_slb"
  address_type       = "internet"     # 外网的类型
  load_balancer_spec = "slb.s2.small" # loadbalance的型号 
  # count 这样写
  server_id1 = module.ecs[0].this_instance_id[0]
  server_id2 = module.ecs[1].this_instance_id[0]
  # number_of_instances = 2 这样写
  # server_id1         = module.ecs.this_instance_id[0]
  # server_id2         = module.ecs.this_instance_id[1]
}

module "mysql" {
  source         = "terraform-alicloud-modules/rds/alicloud"
  engine         = "MySQL"
  engine_version = "8.0"
  # 数据库为内网数据库，禁止外网访问
  allocate_public_connection = false
  vswitch_id                 = module.vpc.vswitch_ids[0]
  instance_storage           = 20
  period                     = 1
  instance_type              = "rds.mysql.s1.small"
  instance_name              = "WebAppDBInstance"
  instance_charge_type       = "Postpaid"
  # 数据库仅允许内网的ECS访问
  security_ips = [
    "${module.ecs[0].this_private_ip[0]}/32",
    "${module.ecs[1].this_private_ip[0]}/32"
  ]
  tags = {
    Environment = "product"
  }
  # 备份策略 
  # 备份策略为北京时间每天0点备份，并保留7天。
  preferred_backup_period     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  preferred_backup_time       = "16:00Z-17:00Z"
  backup_retention_period     = 7
  log_backup_retention_period = 7
  enable_backup_log           = true
  account_name                = "kevin"
  password                    = "5jejYWzSjZhWQc7G22"
  type                        = "Normal"
  # 数据库创建一个账号并且具有对两个数据库的读写权限。
  privilege = "ReadWrite"
  # 创建两个数据库。
  databases = [
    {
      name          = "db1"
      character_set = "utf8"
      description   = "db1"
    },
    {
      name          = "db2"
      character_set = "utf8"
      description   = "db2"
    },
  ]
}

# 不可以缩进会有空格 影响sed命令
locals {
  user_data = <<EOF
#!/bin/bash
#格式化磁盘并设置开机自动挂载
mkfs.ext4 /dev/vdb && mkdir -p /dataB && /bin/mount /dev/vdb /dataB
echo `blkid /dev/vdb | awk '{print $2}' | sed 's/\"//g'` /dataB ext4 defaults 0 0 >> /etc/fstab
mkfs.ext4 /dev/vdc && mkdir -p /dataC && /bin/mount /dev/vdc /dataC
echo `blkid /dev/vdc | awk '{print $2}' | sed 's/\"//g'` /dataC ext4 defaults 0 0 >> /etc/fstab

#安装nginx
yum install -y nginx
private_ip=`curl http://100.100.100.200/latest/meta-data/private-ipv4`
sed -i "1i$private_ip" /usr/share/nginx/html/index.html
systemctl start nginx
EOF
}

module "vpc" {
  source = "alibaba/vpc/alicloud"

  create             = true
  vpc_name           = "three_layer_webserver_vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["cn-shanghai-l", "cn-shanghai-m"]
  vswitch_cidrs      = ["10.0.0.0/24", "10.0.1.0/24"]
  vpc_tags = {
    Owner       = "kevin"
    Environment = "pro"
  }
  vswitch_tags = {
    Owner        = "kevin"
    Environment  = "pro"
    vswitch_name = "TFVSW-"
  }
}

module "nsg" {
  source = "./modules/nsg"
  vpc_id = module.vpc.this_vpc_id
}

module "ecs" {
  source                      = "alibaba/ecs-instance/alicloud"
  count                       = 2
  name                        = "web-${count.index + 1}"
  image_id                    = "centos_7_9_x64_20G_alibase_20220824.vhd"
  instance_type               = "ecs.c7.large"
  vswitch_id                  = module.vpc.this_vswitch_ids[count.index]
  security_group_ids          = [module.nsg.nsg_id]
  associate_public_ip_address = true
  internet_max_bandwidth_out  = 10
  password                    = "5jejYWzSjZhWQc7G22"
  system_disk_category        = "cloud_essd"
  user_data                   = local.user_data
  system_disk_size            = 50
  data_disks = [
    {
      size     = "20"
      name     = "data_diskB"
      category = "cloud_essd"
    },
    {
      size     = "40"
      name     = "data_diskC"
      category = "cloud_essd"
    }
  ]
}


module "slb" {
  source             = "./modules/slb"
  load_balancer_name = "web_slb"
  address_type       = "internet"
  load_balancer_spec = "slb.s2.small"
  server_id1         = module.ecs[0].this_instance_id[0]
  server_id2         = module.ecs[1].this_instance_id[0]
}

module "rds" {
  source         = "terraform-alicloud-modules/rds/alicloud"
  engine         = "MySQL"
  engine_version = "8.0"
  # connection_prefix    = "developmentabc"
  allocate_public_connection = false

  vswitch_id           = module.vpc.vswitch_ids[0]
  instance_storage     = 20
  instance_type        = "rds.mysql.s1.small"
  instance_name        = "myDBInstance"
  instance_charge_type = "Postpaid"
  security_ips = [
    #"0.0.0.0/0",
    "${module.ecs[0].this_private_ip[0]}/32",
    "${module.ecs[1].this_private_ip[0]}/32"
  ]
  tags = {
    Created     = "Terraform"
    Environment = "dev"
  }

  #backup_policy
  preferred_backup_period     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  preferred_backup_time       = "16:00Z-17:00Z"
  backup_retention_period     = 7
  log_backup_retention_period = 7
  enable_backup_log           = true

  #databases#
  account_name = "kevin"
  password     = "5jejYWzSjZhWQc7G22"
  type         = "Normal"
  privilege    = "ReadWrite"
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
    }
  ]
}

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


# output "vpcid" {
#   description = "The instance ids."
#   value       = module.vpc.this_vswitch_ids
# }

# output "aa" {
#   value       = module.ecs[0].this_instance_id
# }
# output "bb" {
#   value       = module.ecs[1].this_instance_id
# }



# 课程名称：Terraform从0基础到上手项目 (DevOps自动化运维开发——IaC基础设施即代码）
# 课程链接：https://edu.51cto.com/course/33054.html
# 祝同学们工作顺利！
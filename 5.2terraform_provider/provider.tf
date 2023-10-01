# provider文件的两种表示方式
################ 第一种 合并设置 ################

# # 定义provider
# terraform {
#   required_providers {
#     alicloud = {
#       source  = "aliyun/alicloud"
#       version = "1.192.0"
#     }
#   }
# }

# 配置provider
provider "alicloud" {
  region     = "cn-shanghai"
  access_key = var.ALICLOUD_ACCESS_KEY
  secret_key = var.ALICLOUD_SECRET_KEY
}
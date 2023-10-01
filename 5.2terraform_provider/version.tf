# provider文件的两种表示方式
################ 第二种 分开设置 ################
# .
# ├── main.tf
# ├── provider.tf
# └── version.tf

# 定义provider (配置provider写在provider.tf中)
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.193.0"
    }
  }
}
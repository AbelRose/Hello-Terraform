# 定义provider
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.194.0"
    }
  }
}
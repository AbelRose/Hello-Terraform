provider "alicloud" {
  region     = "cn-shanghai"
  access_key = ""
  secret_key = ""
}

# 让根目录认识 module vpc
module "vpc" {
  source = "./modules/vpc"
}

# 让根目录认识 module vsw
module "vsw" {
  source = "./modules/vsw"
  # !!! 中转: 传入传出整合进行联动
  # vsw中variable的变量传入来自于vpc模块中vpc的vpc_id
  vpc_id = module.vpc.vpc_id
}
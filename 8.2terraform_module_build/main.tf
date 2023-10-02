# 定义并引用这三个module
module "ecs" {
    source = "./modules/ecs"
    vswitch_id = module.vpc.vswitch_id
    security_groups = module.nsg.nsg_id
}

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    vswitch_cidr = var.vswitch_cidr
}

module "nsg" {
    source = "./modules/nsg"
    vpc_id = module.vpc.vpc_id
}
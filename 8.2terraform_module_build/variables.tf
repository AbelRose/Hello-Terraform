variable region {
  type = string
  description = "region"
}

variable "alicloud_access_key" {
  type        = string
  description = "alicloud_access_key"
}

variable "alicloud_secret_key" {
  type        = string
  description = "alicloud_secret_key"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc_cidr"
}

variable "vswitch_cidr" {
  type        = string
  description = "vswitch_cidr"
}
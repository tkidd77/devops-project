variable "chef_environment" {
  default = "default"
}

variable "vpc_id" {
  type = "map"
  default {
    tkidd_aws = "vpc-af001ecb"
  }
}

variable "aws_region" {
  type = "map"
  default {
    tkidd_aws = "us-east-1"
  }
}

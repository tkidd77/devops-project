variable "aws_key_name" {
  type = "map"
  default {
    default = "default"
  }
}

#--------------------------------------------------------------
# Hello_World Instance(s)
#--------------------------------------------------------------

variable "spot_price" {
  type = "map"
  default {
    default = "0.0125"
  }
}

variable "wait_for_fulfillment" {
  type = "map"
  default {
    default = true
  }
}

variable "spot_type" {
  type = "map"
  default {
    default = "one-time"
  }
}

variable "ami_id" {
  type = "map"
  default {
    default = "ami-0b7b74ba8473ec232"
  }
}

variable "instance_root_ebs_size" {
  type = "map"
  default {
    default = "32"
  }
}

variable "block_device_delete_on_termination" {
  type = "map"
  default {
    default = "true"
  }
}

variable "availability_zones" {
  type = "map"
  default {
    default = ["A"]
  }
}

variable "instance_name" {
  type = "map"
  default {
    default = "Hello_World"
  }
}

variable "subnet_ids" {
  type = "map"
  default {
    default = [""]
  }
}

variable "instance_type" {
  type = "map"
  default {
    default = "t3.medium"
  }
}

variable "number_of_instances" {
  type = "map"
  default {
    default = "1"
  }
}

variable "chef_runlist" {
  type = "map"
  default {
    default = "recipe[Hello_World::default]"
  }
}

# Security Group(s)

variable "aws_security_group_name_rdp" {
  type = "map"
  default {
    default = "sg_allow_tim_home_rdp"
  }
}

variable "aws_security_group_name_web" {
  type = "map"
  default {
    default = "sg_allow_all_web"
  }
}

variable "aws_security_group_name_out" {
  type = "map"
  default {
    default = "sg_allow_all_out"
  }
}

variable "aws_security_group_name_lb" {
  type = "map"
  default {
    default = "sg_allow_lb_http"
  }
}

variable "aws_security_group_desc" {
  default = "Security Group"
}

variable "aws_security_group_vpc_id" {
  type = "map"
  default {
    default = "vpc-fb84879e"
  }
}

#--------------------------------------------------------------
# Hello World ALB
#--------------------------------------------------------------
variable "alb_name" {
  type = "map"
  default {
    default = "Hello-World-ALB"
  }
}

variable "alb_subnets" {
  type = "map"
  default {
    default = ["subnet-b88514dd", "subnet-dab5e7ad"]
  }
}

variable "alb_internal" {
  type = "map"
  default {
    default = false
  }
}

variable "alb_health_check_path" {
  type = "map"
  default {
    default = "/"
  }
}

variable "alb_health_check_matcher_rd" {
  type = "map"
  default {
    default = 200
  }
}

variable "alb_security_groups" {
  type = "map"
  default {
    default = [""]
  }
}

variable "alb_create_count" {
  type = "map"
  default {
    default = 1
  }
}

variable "alb_certificate" {
  type = "map"
  default {
    default = "arn:aws:acm:us-east-1:982848110258:certificate/5a5886e5-8b1e-4e24-951c-4f0c2edf305e"
  }
}

# ALB_Target_Group

variable "alb_target_group_name" {
  type = "map"
  default {
    default = "Hello-World-ALB-TG"
  }
}

variable "alb_target_group_name_redirect" {
  type = "map"
  default {
    default = "Hello-World-ALB-TG-RD"
  }
}

variable "alb_target_group_vpc_id" {
  type = "map"
  default {
    default = "vpc-fb84879e"
  }
}

# Outputs

variable "chef_environment" {
  type = "string"
}

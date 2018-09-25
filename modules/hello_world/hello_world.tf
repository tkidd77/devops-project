# SGs

resource "aws_security_group" "sg_allow_tim_home_rdp" {
  name = "${var.aws_security_group_name_rdp[var.chef_environment]}"
  description = "${var.aws_security_group_desc}"
  vpc_id = "${var.aws_security_group_vpc_id[var.chef_environment]}"
}

resource "aws_security_group" "sg_allow_http_https_all" {
  name = "${var.aws_security_group_name_web[var.chef_environment]}"
  description = "${var.aws_security_group_desc}"
  vpc_id = "${var.aws_security_group_vpc_id[var.chef_environment]}"
}

resource "aws_security_group" "sg_allow_all_out" {
  name = "${var.aws_security_group_name_out[var.chef_environment]}"
  description = "${var.aws_security_group_desc}"
  vpc_id = "${var.aws_security_group_vpc_id[var.chef_environment]}"
}

resource "aws_security_group" "sg_allow_HTTP_from_LB" {
  name = "${var.aws_security_group_name_lb[var.chef_environment]}"
  description = "${var.aws_security_group_desc}"
  vpc_id = "${var.aws_security_group_vpc_id[var.chef_environment]}"
}

# EC2 Instance(s) (non auto scaling)

# resource "aws_spot_instance_request" "instances" {
#   count                     = "${var.number_of_instances[var.chef_environment]}"
#   subnet_id                 = "${element(var.subnet_ids[var.chef_environment], count.index)}"
#   instance_type             = "${var.instance_type[var.chef_environment]}"
#   ami                       = "${var.ami_id[var.chef_environment]}"
#   vpc_security_group_ids    = ["${aws_security_group.sg_allow_tim_home_rdp.id}","${aws_security_group.sg_allow_HTTP_from_LB.id}","${aws_security_group.sg_allow_all_out.id}"]

#   spot_price = "${var.spot_price[var.chef_environment]}"
#   wait_for_fulfillment = "${var.wait_for_fulfillment[var.chef_environment]}"
#   spot_type = "${var.spot_type[var.chef_environment]}"

#   key_name                  = "${var.aws_key_name[var.chef_environment]}"

#   root_block_device {
#    volume_size              = "${var.instance_root_ebs_size[var.chef_environment]}"
#      delete_on_termination  = "${var.block_device_delete_on_termination[var.chef_environment]}"
#   }

#   lifecycle {
#     ignore_changes = ["user_data"]
#   }

#    user_data = <<EOT
#    <powershell>
#     Set-ExecutionPolicy unrestricted -Force

#     New-Item c:/temp -ItemType Directory -Force
#     set-location c:/temp

#     wget -Uri https://s3.amazonaws.com/tkidd-util/chef-client-14.4.56-1-x64.msi -OutFile C:/temp/chef-client.msi

#     Start-Process C:/temp/chef-client.msi /qn -Wait

#     New-Item c:/chef -ItemType Directory -Force
#     set-location c:/chef

#     wget -Uri https://s3.amazonaws.com/tkidd-util/client.rb -OutFile "C:/chef/client.rb"
#     wget -Uri https://s3.amazonaws.com/tkidd-util/tkidd_demo-validator.pem -OutFile "C:/chef/validation.pem"

#     $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

#     "chef_server_url ""https://api.chef.io/organizations/tkidd_demo""" | Add-Content "C:\chef\client.rb"

#     Chef-Client -r "${var.chef_runlist[var.chef_environment]}" -E "${var.chef_environment}" -L c:\Chef\userData.log
#     </powershell>
#   EOT
# }

resource "aws_security_group_rule" "RDP_in_for_tim" {
  type = "ingress"
  from_port = 3389
  to_port = 3389
  protocol = "tcp"
  cidr_blocks = ["100.14.74.34/32"]
  security_group_id = "${aws_security_group.sg_allow_tim_home_rdp.id}"
}

resource "aws_security_group_rule" "HTTP_in_from_world" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_allow_http_https_all.id}"
}

resource "aws_security_group_rule" "HTTPS_in_from_world" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_allow_http_https_all.id}"
}

resource "aws_security_group_rule" "all_tcp_to_world" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_allow_all_out.id}"
}

resource "aws_security_group_rule" "all_udp_to_world" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_allow_all_out.id}"
}

resource "aws_security_group_rule" "all_http_from_lb" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.sg_allow_HTTP_from_LB.id}"
  security_group_id = "${aws_security_group.sg_allow_HTTP_from_LB.id}"
}

resource "aws_security_group_rule" "all_http_from_lb_2" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.sg_allow_HTTP_from_LB.id}"
  security_group_id = "${aws_security_group.sg_allow_HTTP_from_LB.id}"
}

# ALB

resource "aws_alb" "hello_world_alb" {
  count = "${var.alb_create_count[var.chef_environment]}"
  name = "${var.alb_name[var.chef_environment]}"
  subnets = "${var.alb_subnets[var.chef_environment]}"
  idle_timeout              = 60
  internal                  = "${var.alb_internal[var.chef_environment]}"
  security_groups           = ["${aws_security_group.sg_allow_HTTP_from_LB.id}","${aws_security_group.sg_allow_http_https_all.id}"]
}

# ALB Target Group

resource "aws_alb_target_group" "hello_world_alb_tar_grp" {
  name     = "${var.alb_target_group_name[var.chef_environment]}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.alb_target_group_vpc_id[var.chef_environment]}"
  deregistration_delay = 15

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 4
    timeout             = 10
    interval            = 30
    path                = "${var.alb_health_check_path[var.chef_environment]}"
  }
}

# # ALB target group attachment

# resource "aws_alb_target_group_attachment" "hello_world_alb_tar_grp_attach" {
#   count            = "${var.number_of_instances[var.chef_environment]}"
#   target_group_arn = "${aws_alb_target_group.hello_world_alb_tar_grp.arn}"
#   target_id        = "${element(aws_spot_instance_request.instances.*.spot_instance_id, count.index)}"
#   port             = 80
# }

# ALB listeners

resource "aws_alb_listener" "hello_world_alb_lis_443" {
  load_balancer_arn = "${aws_alb.hello_world_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.alb_certificate[var.chef_environment]}"

  default_action {
    target_group_arn = "${aws_alb_target_group.hello_world_alb_tar_grp.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "hello_world_alb_lis_80" {
  load_balancer_arn = "${aws_alb.hello_world_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol         = "HTTPS"
      status_code      = "HTTP_301"
    }
  }
}

# Auto scaling

# Auto scaling placement group

resource "aws_placement_group" "hello_world" {
  name     = "test"
  strategy = "cluster"
}

# Launch configuration

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "${var.ami_id[var.chef_environment]}"
  instance_type = "${var.instance_type[var.chef_environment]}"
  key_name      = "${var.aws_key_name[var.chef_environment]}"
  security_groups = ["${aws_security_group.sg_allow_tim_home_rdp.id}","${aws_security_group.sg_allow_HTTP_from_LB.id}","${aws_security_group.sg_allow_all_out.id}"]
  spot_price = "${var.spot_price[var.chef_environment]}"
  root_block_device {
    volume_size = "${var.instance_root_ebs_size[var.chef_environment]}"
    delete_on_termination = "${var.block_device_delete_on_termination[var.chef_environment]}"
  }
  user_data     = <<EOT
   <powershell>
    Set-ExecutionPolicy unrestricted -Force

    New-Item c:/temp -ItemType Directory -Force
    set-location c:/temp

    wget -Uri https://s3.amazonaws.com/tkidd-util/chef-client-14.4.56-1-x64.msi -OutFile C:/temp/chef-client.msi

    Start-Process C:/temp/chef-client.msi /qn -Wait

    New-Item c:/chef -ItemType Directory -Force
    set-location c:/chef

    wget -Uri https://s3.amazonaws.com/tkidd-util/client.rb -OutFile "C:/chef/client.rb"
    wget -Uri https://s3.amazonaws.com/tkidd-util/tkidd_demo-validator.pem -OutFile "C:/chef/validation.pem"

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

    "chef_server_url ""https://api.chef.io/organizations/tkidd_demo""" | Add-Content "C:\chef\client.rb"

    Chef-Client -r "${var.chef_runlist[var.chef_environment]}" -E "${var.chef_environment}" -L c:\Chef\userData.log
    </powershell>
  EOT

  lifecycle {
    create_before_destroy = true
  }
}

# Auto scaling group

resource "aws_autoscaling_group" "bar" {
  name                      = "hello_world"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  placement_group           = "${aws_placement_group.hello_world.id}"
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  vpc_zone_identifier       = ["subnet-277b0c7e"]
  target_group_arns         = ["${aws_alb_target_group.hello_world_alb_tar_grp.arn}"]
}

# Scaling Policy

resource "aws_autoscaling_policy" "cpu" {
  name                   = "70%_cpu"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = "450"
  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }
  target_value = 70.0
}
  autoscaling_group_name = "${aws_autoscaling_group.bar.name}"
}

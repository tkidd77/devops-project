# output "alb_cname" {
#   description = "ALB CNAME"
#   value = "${aws_alb.hello_world_alb.dns_name}"
# }

# output "ip" {
#   description = "ALB CNAME"
#   value = ["${aws_alb.hello_world_alb.*.dns_name}"]
# }

output "ip" {
  description = "ALB CNAME"
  value = "${element(aws_alb.hello_world_alb.*.dns_name, 1)}"
}

output "zone_id" {
  description = "ALB zone_id"
  value = "${element(aws_alb.hello_world_alb.*.zone_id, 1)}"
}

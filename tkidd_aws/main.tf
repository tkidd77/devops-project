module "modules" {
  source = "..\\modules"
}

module "hello_world" {
  source = "..\\modules\\hello_world"
  chef_environment = "${var.chef_environment}"
}

module "route53-server-name" {
  source = "..\\modules\\route53-server-name"
  ip = "${module.hello_world.ip}"
  zone_id = "${module.hello_world.zone_id}"
}
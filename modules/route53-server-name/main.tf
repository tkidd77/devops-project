data "aws_route53_zone" "this" {
  name         = "${var.domain}"
  #private_zone = "${var.private_zone}"
}

resource "aws_route53_record" "this" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "${var.name}"
  type    = "${var.type}"

  alias {
    name                   = "${var.ip}"
    zone_id                = "${var.zone_id}"
    evaluate_target_health = true
  }

}

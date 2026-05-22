resource "aws_route53_record" "dev_system_01" {
  depends_on = [aws_eip.dev_system_01, module.dev_system_01]
  zone_id    = local.dev_ec2_zone
  name       = "${local.dev_ec2_name}.${local.dev_ec2_postfix}"
  type       = "A"
  ttl        = "300"
  records    = ["${module.dev_system_01.private_ip}"]
}

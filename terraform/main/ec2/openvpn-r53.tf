resource "aws_route53_record" "openvpn" {
  depends_on = [aws_eip.openvpn, module.openvpn]
  zone_id    = local.openvpn_ec2_zone
  name       = "${local.openvpn_ec2_name}.${local.openvpn_ec2_postfix}"
  type       = "A"
  ttl        = "300"
  records    = ["${module.openvpn.public_ip}"]
}

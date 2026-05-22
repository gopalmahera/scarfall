resource "aws_route53_record" "sonarqube_system" {
  depends_on = [aws_eip.sonarqube_system, module.sonarqube_system]
  zone_id    = local.sonarqube_ec2_zone
  name       = "${local.sonarqube_ec2_name}.${local.sonarqube_ec2_postfix}"
  type       = "A"
  ttl        = "300"
  records    = ["${module.sonarqube_system.public_ip}"]
}

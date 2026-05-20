resource "aws_route53_zone" "public" {
  name = local.public_zone_name

  tags = merge(var.tags, local.tags, {
    "module" = "zone",
    }
  )
}

resource "aws_route53_record" "public_dns_records" {
  for_each = local.public_records

  zone_id = aws_route53_zone.public.id
  name    = "${each.key}.${local.public_zone_name}"
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}

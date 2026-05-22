output "public_zone_id" {
  value = aws_route53_zone.public.id
}

output "public_zone_name" {
  value = aws_route53_zone.public.name
}

output "private_zone_id" {
  value = aws_route53_zone.private.id
}

output "private_zone_name" {
  value = aws_route53_zone.private.name
}

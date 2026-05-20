resource "aws_route53_zone" "private" {
  name = local.private_zone_name

  vpc {
    vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
    vpc_region = var.region
  }
  vpc {
    vpc_id     = "vpc-011aea6bb9ae40a9f"
    vpc_region = "ap-south-1"
  }

  vpc {
    vpc_id     = "vpc-0e816d20e0c590a97"
    vpc_region = "ap-south-1"
  }

  tags = merge(var.tags, local.tags, {
    "module" = "zone",
    }
  )
}

resource "aws_route53_record" "private_dns_records" {
  for_each = local.private_records

  zone_id = aws_route53_zone.private.id
  name    = "${each.key}.${local.private_zone_name}"
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}

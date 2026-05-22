module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = local.name
  cidr = local.cidr
  azs  = data.aws_availability_zones.az.names

  public_subnets = local.public_subnets

  public_dedicated_network_acl = local.public_dedicated_network_acl

  manage_default_network_acl = false
  public_inbound_acl_rules   = local.public_inbound_acl_rules
  public_outbound_acl_rules  = local.public_outbound_acl_rules

  enable_nat_gateway   = local.enable_nat_gateway
  single_nat_gateway   = local.single_nat_gateway
  enable_dns_hostnames = local.enable_dns_hostnames

  enable_flow_log = false

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "vpc" }
  )
}

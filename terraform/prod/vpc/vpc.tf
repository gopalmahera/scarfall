module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 6.0.0, < 7.0.0"

  name = local.name
  cidr = local.cidr
  azs  = data.aws_availability_zones.az.names

  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  database_subnets = local.database_subnets

  create_database_subnet_route_table = true
  map_public_ip_on_launch            = true

  public_dedicated_network_acl   = local.public_dedicated_network_acl
  private_dedicated_network_acl  = local.private_dedicated_network_acl
  database_dedicated_network_acl = local.database_dedicated_network_acl

  manage_default_network_acl  = false
  public_inbound_acl_rules    = local.public_inbound_acl_rules
  public_outbound_acl_rules   = local.public_outbound_acl_rules
  private_inbound_acl_rules   = local.private_inbound_acl_rules
  private_outbound_acl_rules  = local.private_outbound_acl_rules
  database_inbound_acl_rules  = local.database_inbound_acl_rules
  database_outbound_acl_rules = local.database_outbound_acl_rules

  enable_nat_gateway   = local.enable_nat_gateway
  single_nat_gateway   = local.single_nat_gateway
  enable_dns_hostnames = local.enable_dns_hostnames
  enable_flow_log      = false

  public_subnet_tags = merge(
    local.eks_subnet_tags,
    { "kubernetes.io/role/elb" = "1" },
    { "kubernetes.io/subnet/discovery" = "${local.name}-public" }
  )
  private_subnet_tags = merge(
    local.eks_subnet_tags,
    { "kubernetes.io/role/internal-elb" = "1" },
    { "kubernetes.io/subnet/discovery" = "${local.name}-private" }
  )
  intra_subnet_tags = merge(
    local.eks_subnet_tags,
    { "kubernetes.io/role/internal-elb" = "1" },
    { "kubernetes.io/subnet/discovery" = "${local.name}-intra" }
  )

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "vpc" }
  )
}

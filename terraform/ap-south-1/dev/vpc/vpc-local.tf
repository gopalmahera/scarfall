locals {
  name                           = "scarfall-dev"
  cidr                           = "10.60.0.0/16"
  public_subnets                 = ["10.60.0.0/20", "10.60.16.0/20", "10.60.32.0/20"]
  public_dedicated_network_acl   = true
  private_subnets                = ["10.60.48.0/20", "10.60.64.0/20", "10.60.80.0/20"]
  private_dedicated_network_acl  = true
  database_subnets               = ["10.60.96.0/20", "10.60.112.0/20", "10.60.128.0/20"]
  database_dedicated_network_acl = true

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true


  public_inbound_acl_rules = [
    { "rule_number" : 100, "protocol" : "6", "from_port" : 80, "to_port" : 80, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 200, "protocol" : "6", "from_port" : 443, "to_port" : 443, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 300, "protocol" : "6", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 310, "protocol" : "17", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9800, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.60.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9810, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.50.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9900, "protocol" : "6", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9901, "protocol" : "17", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
  ]
  public_outbound_acl_rules = [
    { "rule_number" : 100, "protocol" : "6", "from_port" : 80, "to_port" : 80, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 200, "protocol" : "6", "from_port" : 443, "to_port" : 443, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 300, "protocol" : "6", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 310, "protocol" : "17", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 400, "protocol" : "6", "from_port" : 22, "to_port" : 22, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9800, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.60.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9810, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.50.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9900, "protocol" : "6", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9901, "protocol" : "17", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
  ]
  private_inbound_acl_rules = [
    { "rule_number" : 100, "protocol" : "6", "from_port" : 80, "to_port" : 80, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 200, "protocol" : "6", "from_port" : 443, "to_port" : 443, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 300, "protocol" : "6", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 310, "protocol" : "17", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9800, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.60.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9810, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.50.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9900, "protocol" : "6", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
  ]
  private_outbound_acl_rules = [
    { "rule_number" : 100, "protocol" : "6", "from_port" : 80, "to_port" : 80, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 200, "protocol" : "6", "from_port" : 443, "to_port" : 443, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 300, "protocol" : "6", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 310, "protocol" : "17", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 400, "protocol" : "6", "from_port" : 22, "to_port" : 22, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9800, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.60.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9810, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.50.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9900, "protocol" : "6", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
  ]
  database_inbound_acl_rules = [
    { "rule_number" : 100, "protocol" : "6", "from_port" : 80, "to_port" : 80, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 200, "protocol" : "6", "from_port" : 443, "to_port" : 443, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 300, "protocol" : "6", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 310, "protocol" : "17", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9800, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.60.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9810, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.50.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9900, "protocol" : "6", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
  ]
  database_outbound_acl_rules = [
    { "rule_number" : 100, "protocol" : "6", "from_port" : 80, "to_port" : 80, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 200, "protocol" : "6", "from_port" : 443, "to_port" : 443, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 300, "protocol" : "6", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 310, "protocol" : "17", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 400, "protocol" : "6", "from_port" : 22, "to_port" : 22, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9800, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.60.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9810, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.50.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9900, "protocol" : "6", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
  ]

  eks_clusters = ["scarfall-dev"]
  eks_subnet_tags = {
    for tag in local.eks_clusters :
    "kubernetes.io/cluster/${tag}" => "shared"
  }
}

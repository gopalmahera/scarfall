locals {
  name                         = "scarfall-main"
  cidr                         = "10.50.0.0/16"
  public_subnets               = ["10.50.0.0/20", "10.50.16.0/20", "10.50.32.0/20"]
  public_dedicated_network_acl = true

  enable_dns_hostnames = true
  enable_nat_gateway   = false
  single_nat_gateway   = false

  public_inbound_acl_rules = [
    { "rule_number" : 100, "protocol" : "6", "from_port" : 80, "to_port" : 80, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 200, "protocol" : "6", "from_port" : 443, "to_port" : 443, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 300, "protocol" : "6", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 310, "protocol" : "17", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 1000, "protocol" : "6", "from_port" : 22, "to_port" : 22, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9800, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.50.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9810, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.60.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9900, "protocol" : "6", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
  ]
  public_outbound_acl_rules = [
    { "rule_number" : 100, "protocol" : "6", "from_port" : 80, "to_port" : 80, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 200, "protocol" : "6", "from_port" : 443, "to_port" : 443, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 300, "protocol" : "6", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 310, "protocol" : "17", "from_port" : 53, "to_port" : 53, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
    { "rule_number" : 9800, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.50.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9810, "protocol" : "-1", "from_port" : 0, "to_port" : 0, "cidr_block" : "10.60.0.0/16", "rule_action" : "allow" },
    { "rule_number" : 9900, "protocol" : "6", "from_port" : 1024, "to_port" : 65535, "cidr_block" : "0.0.0.0/0", "rule_action" : "allow" },
  ]
}

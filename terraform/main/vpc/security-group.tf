module "sg_egress_all_all" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "vpcsg-comm-egress-all-all"
  description = "[scarfall-common] Allow Egress to Any"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "vpcsg-comm-egress-all-all" }
  )
}

module "sg_egress_all_vpc" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "vpcsg-comm-egress-all-vpc"
  description = "[scarfall-common] Allow Egress to VPC & Peerting Connection"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    { rule = "all-all", cidr_blocks = "${local.cidr}" },
  ]

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "vpcsg-comm-egress-all-vpc" }
  )
}

module "sg_openvpn" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "vpcsg-openvpn"
  description = "Allow Ingress Opnn Connection"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 1194
      to_port     = 1194
      protocol    = "tcp"
      description = "OpenVPN Port allow from all"
      cidr_blocks = "0.0.0.0/0"
    },
    # {
    #   rule        = "ssh-tcp"
    #   cidr_blocks = "0.0.0.0/0"
    # },
  ]

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "vpcsg-openvpn" }
  )
}

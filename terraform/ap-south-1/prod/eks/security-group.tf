module "sg_eks_internal" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2"

  name        = "${local.cluster_name}-eks-internal"
  description = "Allow Internal Traffic"
  vpc_id      = local.vpc_id

  computed_ingress_with_self = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Service name"
      self        = true
    }
  ]
  number_of_computed_ingress_with_self = 1
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 1024
      to_port     = 65535
      protocol    = -1
      description = "Allow from VPN Network"
      cidr_blocks = "10.50.0.0/16"
    }
  ]

  tags = merge(
    var.tags,
    { "custom-module" = "eks-cluster" },
    local.node_security_group_tags
  )
}

resource "aws_security_group_rule" "addon-rule1" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.eks.cluster_security_group_id
  security_group_id        = module.sg_eks_internal.security_group_id
  description              = "Allow workers pods to receive communication from the cluster control plane."
}

resource "aws_security_group_rule" "addon-rule2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.sg_eks_internal.security_group_id
  description              = "Allow workers pods to receive communication from the cluster control plane."
}


module "sg_eks_gameplay" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2"

  name        = "${local.cluster_name}-eks-gameplay"
  description = "Allow Internal UDP Traffic"
  vpc_id      = local.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 1024
      to_port     = 65535
      protocol    = 17
      description = "UDP support"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = merge(
    var.tags,
    { "custom-module" = "eks-cluster" },
    local.node_security_group_tags,

  )
}

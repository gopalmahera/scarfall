module "sg_dev_system_01" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${local.dev_ec2_name}-ingress"
  description = "Allow Ingress from OpenVPN Server"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "Allow from OpenVPN Server only"
      source_security_group_id = data.terraform_remote_state.vpc.outputs.sg_iopenvpn
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1


  tags = merge(var.tags, local.tags,
    { "tf_module" = "sg_dev_system_01" }
  )
}



module "dev_system_01" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  name                    = "${local.dev_ec2_name}.${local.dev_ec2_postfix}"
  ami                     = local.dev_ec2_ami
  instance_type           = local.dev_ec2_instance_type
  key_name                = local.dev_ec2_key_name
  monitoring              = local.dev_ec2_monitoring
  subnet_id               = local.openvpn_ec2_subnet_id
  root_block_device       = local.dev_ec2_root_block_device
  disable_api_termination = local.dev_ec2_disable_api_termination
  # iam_instance_profile    = local.dev_ec2_iam_instance_profile

  vpc_security_group_ids = [
    module.sg_dev_system_01.security_group_id,
    data.terraform_remote_state.vpc.outputs.sg_egress_all_all,
    "sg-07a71bf962ca0022a"
  ]

  tags = merge(var.tags, local.tags, {
    "NodeExporte" = "False",
    "environment" = "main",
    "ec2_group"   = "dev-system",
    "module"      = "ec2",
    }
  )
}

resource "aws_eip" "dev_system_01" {
  instance = module.dev_system_01.id

  tags = merge(var.tags, local.tags, {
    "Name"        = "${local.dev_ec2_name}.${local.dev_ec2_postfix}"
    "environment" = "main",
    "ec2_group"   = "dev-system",
    "module"      = "ec2",
    }
  )
}

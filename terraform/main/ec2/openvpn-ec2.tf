

module "openvpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  name                    = "${local.openvpn_ec2_name}.${local.openvpn_ec2_postfix}"
  ami                     = local.openvpn_ec2_ami
  instance_type           = local.openvpn_ec2_instance_type
  key_name                = local.openvpn_ec2_key_name
  monitoring              = local.openvpn_ec2_monitoring
  subnet_id               = local.openvpn_ec2_subnet_id
  root_block_device       = local.openvpn_ec2_root_block_device
  disable_api_termination = local.openvpn_ec2_disable_api_termination
  # iam_instance_profile    = local.openvpn_ec2_iam_instance_profile

  vpc_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.sg_iopenvpn,
    data.terraform_remote_state.vpc.outputs.sg_egress_all_all,
  ]

  tags = merge(var.tags, local.tags, {
    "NodeExporte" = "False",
    "environment" = "main",
    "ec2_group"   = "openvpn",
    "module"      = "ec2",
    }
  )
}

resource "aws_eip" "openvpn" {
  instance = module.openvpn.id

  tags = merge(var.tags, local.tags, {
    "Name"        = "${local.openvpn_ec2_name}.${local.openvpn_ec2_postfix}"
    "environment" = "main",
    "ec2_group"   = "openvpn",
    "module"      = "ec2",
    }
  )
}

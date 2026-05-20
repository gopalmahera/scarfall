locals {
  dev_ec2_name                    = "dev-system-01"
  dev_ec2_ami                     = "ami-00bb6a80f01f03502"
  dev_ec2_instance_type           = "t3a.medium"
  dev_ec2_key_name                = "main-dev"
  dev_ec2_monitoring              = false
  dev_ec2_disable_api_termination = false
  # dev_ec2_iam_instance_profile    = "AmazonSSMRoleForInstancesQuickSetup"
  dev_ec2_zone      = data.terraform_remote_state.route53.outputs.private_zone_id
  dev_ec2_postfix   = data.terraform_remote_state.route53.outputs.private_zone_name
  dev_ec2_subnet_id = data.terraform_remote_state.vpc.outputs.vpc_public_subnets_id[0]

  dev_ec2_root_block_device = [{
    device_name           = "/dev/sda"
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = false
  }]
}

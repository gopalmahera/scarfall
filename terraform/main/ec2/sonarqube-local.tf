locals {
  sonarqube_ec2_name                    = "sonarqube"
  sonarqube_ec2_ami                     = "ami-00bb6a80f01f03502"
  sonarqube_ec2_instance_type           = "t3a.medium"
  sonarqube_ec2_key_name                = "sonarqube"
  sonarqube_ec2_monitoring              = false
  sonarqube_ec2_disable_api_termination = false
  # sonarqube_ec2_iam_instance_profile    = "AmazonSSMRoleForInstancesQuickSetup"
  sonarqube_ec2_zone      = data.terraform_remote_state.route53.outputs.public_zone_id
  sonarqube_ec2_postfix   = data.terraform_remote_state.route53.outputs.public_zone_name
  sonarqube_ec2_subnet_id = data.terraform_remote_state.vpc.outputs.vpc_public_subnets_id[0]

  sonarqube_ec2_root_block_device = [{
    device_name           = "/dev/sda"
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = false
  }]
}

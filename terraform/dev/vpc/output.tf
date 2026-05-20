output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_blocks" {
  value = local.cidr
}

output "vpc_public_subnets_id" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnets_id" {
  value = module.vpc.private_subnets
}

output "vpc_database_subnets_id" {
  value = module.vpc.database_subnets
}

output "sg_egress_all_all" {
  value = module.sg_egress_all_all.security_group_id
}

output "sg_egress_all_vpc" {
  value = module.sg_egress_all_vpc.security_group_id
}

output "sg_iopenvpn" {
  value = module.sg_openvpn.security_group_id
}

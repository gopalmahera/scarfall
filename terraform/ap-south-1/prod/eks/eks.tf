module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  bootstrap_self_managed_addons            = true

  cluster_addons = local.cluster_addons

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids

  node_security_group_tags = local.node_security_group_tags

  eks_managed_node_group_defaults = {
    vpc_security_group_ids = [module.sg_eks_internal.security_group_id]
    create_launch_template = true
    public_ip              = false
    desired_size           = 0
    max_size               = 0
    min_size               = 0
    iam_role_additional_policies = {
      CloudWatchAgentServerPolicy  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
    subnets = local.private_subnet_ids
  }

  eks_managed_node_groups = {
    for name, ng in local.node_groups : name => merge({
      desired_size   = ng.desired_size
      max_size       = ng.max_size
      min_size       = ng.min_size
      instance_types = ng.instance_types
      ami_type       = ng.ami_type
      disk_size      = ng.disk_size

      update_config = {
        max_unavailable_percentage = 50
      }

      },
      contains(keys(ng), "labels") ? { labels = ng.labels } : { labels = { node_group = name } },
      contains(keys(ng), "tags") ? { tags = ng.tags } : { tags = { node_group = name } },
      contains(keys(ng), "capacity_type") ? { capacity_type = ng.capacity_type } : {},
      contains(keys(ng), "ami_type") ? { ami_type = ng.ami_type } : {},
      contains(keys(ng), "security_group_ids") ? { vpc_security_group_ids = ng.security_group_ids } : {},
      contains(keys(ng), "iam_role_additional_policies") ? { iam_role_additional_policies = ng.iam_role_additional_policies } : {},
      contains(keys(ng), "subnet_ids") ? { subnet_ids = ng.subnet_ids } : {},
      contains(keys(ng), "disk_size") ? { disk_size = ng.disk_size } : {},
      contains(keys(ng), "ebs_optimized") ? { ebs_optimized = ng.ebs_optimized } : {},
      contains(keys(ng), "cloudinit_post_nodeadm") ? { enable_bootstrap_user_data = true } : {},
      contains(keys(ng), "cloudinit_post_nodeadm") ? { cloudinit_post_nodeadm = ng.cloudinit_post_nodeadm } : {},
      contains(keys(ng), "ebs_optimized") ? { block_device_mappings = [for k, v in local.block_device_mappings : {
        device_name = v.device_name
        ebs = {
          volume_size           = ng.disk_size
          volume_type           = v.ebs.volume_type
          delete_on_termination = v.ebs.delete_on_termination
          throughput            = v.ebs.throughput
          encrypted             = v.ebs.encrypted
        }
      }] } : {},

      contains(keys(ng), "taints") ? { taints = [for k, v in local.taints : {
        key    = v.key
        value  = v.value
        effect = v.effect
      }] } : {},
    )
  }

  tags = merge(
    var.tags,
    local.tags,
    { "custom-module" = "eks-cluster" },
    { "tf_module" = "eks-cluster" }
  )
}

# https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html
# The IDs of subnets to launch Pods into that use this profile. At this time, Pods that are running on Fargate aren’t assigned public IP addresses. Therefore, only private subnets with no direct route to an Internet Gateway are accepted for this parameter.
# module "eks_fargate_public_profile" {
#   source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

#   name         = "gameplay-public-fargate-profile"
#   cluster_name = local.cluster_name

#   subnet_ids = local.public_subnet_ids
#   selectors = [{
#     namespace = "gameplay-public"
#   }]

#   tags = merge(
#     var.tags,
#     local.tags,
#     { "custom-module" = "eks-fargate" },
#     { "tf_module" = "eks-cluster" }
#   )
# }

# module "eks_fargate_private_profile" {
#   source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

#   name         = "gameplay-private-fargate-profile"
#   cluster_name = local.cluster_name

#   subnet_ids = local.private_subnet_ids
#   selectors = [{
#     namespace = "fargate-*"
#   }]

#   tags = merge(
#     var.tags,
#     local.tags,
#     { "custom-module" = "eks-fargate" },
#     { "tf_module" = "eks-cluster" }
#   )
# }

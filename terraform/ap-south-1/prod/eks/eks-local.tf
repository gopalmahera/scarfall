locals {
  cluster_name    = "scarfall-prod"
  cluster_version = "1.33"

  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.vpc_private_subnets_id
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.vpc_public_subnets_id

  node_security_group_tags = {
    "kubernetes.io/shared-nodegroup" = "true"
    "kubernetes.io/karpenter"        = local.cluster_name
    "agones-system/game-play"        = "true"
  }

  cluster_addons = {
    coredns = {
      addon_version               = "v1.12.2-eksbuild.4"
      resolve_conflicts_on_update = "PRESERVE"
    }
    eks-pod-identity-agent = {
      addon_version = "v1.3.8-eksbuild.2"
    }
    kube-proxy = {
      addon_version = "v1.33.0-eksbuild.2"
    }
    vpc-cni = {
      addon_version = "v1.19.6-eksbuild.7"
    }
  }

  taints = {
    dedicated = {
      key    = "nodegroup"
      value  = "beta"
      effect = "NO_SCHEDULE"
    }
  }
  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_type           = "gp3"
        delete_on_termination = true
        encrypted             = true
        throughput            = 125
      }
    }
  }

  node_groups = {
    "system" = {
      desired_size   = 1,
      max_size       = 3,
      min_size       = 1,
      disk_size      = 50,
      instance_types = ["m6a.2xlarge"],
      ami_type       = "AL2023_x86_64_STANDARD",
      ebs_optimized  = true,
      subnet_ids     = ["${data.terraform_remote_state.vpc.outputs.vpc_private_subnets_id[1]}"],
    },
  }
}

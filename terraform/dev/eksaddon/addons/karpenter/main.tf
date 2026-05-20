# =============================================================================
# Karpenter Module for EKS
# =============================================================================
# This module deploys Karpenter to an EKS cluster for automatic node provisioning.
# Karpenter is a Kubernetes cluster autoscaler that provisions right-sized compute
# resources in response to changing application load in under 30 seconds.

# =============================================================================
# Random Suffix Generation
# =============================================================================
# Generate a random suffix to ensure unique resource names
# This prevents conflicts when multiple Karpenter instances are deployed
resource "random_string" "random" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}

# =============================================================================
# Karpenter Infrastructure Module
# =============================================================================
# Deploy Karpenter infrastructure components including IAM roles, policies,
# SQS queue, and EC2 instance profiles required for node provisioning
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "21.1.0"

  # EKS cluster configuration
  cluster_name = var.cluster_name

  # Infrastructure components configuration
  # Enable creation of all required AWS resources
  create_instance_profile         = true
  create_access_entry             = true
  create_pod_identity_association = true

  # Namespace and naming configuration
  namespace                     = var.namespace
  iam_policy_use_name_prefix    = false
  node_iam_role_use_name_prefix = false
  iam_role_use_name_prefix      = false

  # Custom resource names with unique suffixes
  iam_policy_name    = "${var.cluster_name}-karpenter-controller-${random_string.random.result}"
  iam_role_name      = "${var.cluster_name}-karpenter-controller-${random_string.random.result}"
  node_iam_role_name = "${var.cluster_name}-karpenter-node-${random_string.random.result}"
  queue_name         = "${var.cluster_name}-karpenter-${random_string.random.result}"

  # Additional IAM policies for enhanced node functionality
  # SSM access allows for session manager connectivity to nodes
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  # Resource tagging
  tags = merge(
    var.tags,
    { "tf_module" = "karpenter" }
  )
}

# =============================================================================
# Local Values for Helm Chart Configuration
# =============================================================================
# Prepare variables for Helm values template
# These values configure the Karpenter controller deployment
locals {
  # Template variables for Helm values
  vars = {
    service_account  = module.karpenter.service_account
    cluster_name     = var.cluster_name
    cluster_endpoint = var.cluster_endpoint
    queue_name       = module.karpenter.queue_name
    role             = module.karpenter.node_iam_role_arn
  }

  # Generate Helm values from template file
  values = templatefile(
    "${path.module}/helm-values.tmpl",
    local.vars
  )
}

# =============================================================================
# Helm Release for Karpenter Controller
# =============================================================================
# Deploy the Karpenter controller using Helm chart
# The controller watches for unschedulable pods and provisions nodes automatically
resource "helm_release" "karpenter" {
  depends_on = [module.karpenter]

  # Helm chart configuration
  namespace        = var.namespace
  name             = var.name
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.helmversion
  create_namespace = true

  # Apply custom values from template
  values = [local.values]
}

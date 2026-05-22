# =============================================================================
# Karpenter Module Variables
# =============================================================================
# This file defines all input variables for the Karpenter module.
# These variables configure the deployment and EKS cluster integration.

# =============================================================================
# AWS Configuration
# =============================================================================
variable "region" {
  description = "AWS region where the EKS cluster is deployed"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to all resources created by this module"
  type        = map(string)
  default     = {}
}

# =============================================================================
# EKS Cluster Configuration
# =============================================================================
variable "cluster_name" {
  description = "Name of the EKS cluster where Karpenter will be deployed"
  type        = string
  default     = null
}

variable "cluster_endpoint" {
  description = "EKS cluster API server endpoint for Karpenter configuration"
  type        = string
  default     = null
}

# =============================================================================
# Karpenter Configuration
# =============================================================================
variable "name" {
  description = "Name for the Karpenter deployment and service account"
  type        = string
  default     = "karpenter"
}

variable "namespace" {
  description = "Kubernetes namespace where Karpenter will be deployed"
  type        = string
  default     = "kube-addons"
}

# =============================================================================
# Version Configuration
# =============================================================================
variable "helmversion" {
  description = "Helm chart version for Karpenter"
  type        = string
  default     = "1.0.8"
}

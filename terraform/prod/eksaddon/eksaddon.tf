data "aws_eks_cluster" "eks" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

resource "local_file" "kubectl_config" {
  content         = data.terraform_remote_state.eks.outputs.kubectl_config
  filename        = "${data.aws_eks_cluster.eks.id}.kubeconfig"
  file_permission = 0400
}

/******************************************
	ALB Controller
 *****************************************/
module "alb_controller" {
  source        = "./addons/alb_controller"
  count         = try(local.addons["alb_controller"].enable, false) ? 1 : 0
  cluster_name  = data.aws_eks_cluster.eks.id
  oidc_provider = data.terraform_remote_state.eks.outputs.oidc_provider
  name          = coalesce(try(local.addons["alb_controller"].name, null), "aws-load-balancer-controller")
  namespace     = coalesce(try(local.addons["alb_controller"].namespace, null), "kube-addons")
  helmversion   = coalesce(try(local.addons["alb_controller"].version, null), "1.10.1")
  release       = coalesce(try(local.addons["alb_controller"].property.release, null), "v2.10.1")
}

/******************************************
	Kubernetes Dashboard
 *****************************************/
module "kubernetes_dashboard" {
  depends_on      = [module.alb_controller]
  source          = "./addons/kubernetes_dashboard"
  count           = try(local.addons["kubernetes_dashboard"].enable, false) ? 1 : 0
  name            = coalesce(try(local.addons["kubernetes_dashboard"].name, null), "kubernetes-dashboard")
  namespace       = coalesce(try(local.addons["kubernetes_dashboard"].namespace, null), "kube-addons")
  helmversion     = coalesce(try(local.addons["kubernetes_dashboard"].version, null), "7.9.0")
  alb_name        = coalesce(try(local.addons["kubernetes_dashboard"].property.alb_name, null), "default")
  url             = coalesce(try(local.addons["kubernetes_dashboard"].property.url, null), "k8s.demo.live")
  external        = coalesce(try(local.addons["kubernetes_dashboard"].property.external, null), false)
  certificate_arn = coalesce(try(local.addons["kubernetes_dashboard"].property.certificate_arn, null), "")
}


/******************************************
	Cluster Auto Scaler
 *****************************************/
module "cluster_autoscaler" {
  source        = "./addons/cluster_autoscaler"
  count         = try(local.addons["cluster_autoscaler"].enable, false) ? 1 : 0
  cluster_name  = data.aws_eks_cluster.eks.id
  oidc_provider = data.terraform_remote_state.eks.outputs.oidc_provider
  region        = var.region
  name          = coalesce(try(local.addons["cluster_autoscaler"].name, null), "clusterautoscaler")
  namespace     = coalesce(try(local.addons["cluster_autoscaler"].namespace, null), "kube-addons")
  helmversion   = coalesce(try(local.addons["cluster_autoscaler"].version, null), "9.43.0")
}

/******************************************
	EBS CSI Driver
 *****************************************/
module "ebs_csi" {
  source        = "./addons/ebs_csi"
  count         = try(local.addons["ebs_csi"].enable, false) ? 1 : 0
  cluster_name  = data.aws_eks_cluster.eks.id
  oidc_provider = data.terraform_remote_state.eks.outputs.oidc_provider
  region        = var.region
  name          = coalesce(try(local.addons["ebs_csi"].name, null), "ebs-csi-driver")
  namespace     = coalesce(try(local.addons["ebs_csi"].namespace, null), "kube-addons")
  helmversion   = coalesce(try(local.addons["ebs_csi"].version, null), "2.38.1")
  release       = coalesce(try(local.addons["ebs_csi"].property.release, null), "v1.38.1")
}

/******************************************
	EFS CSI Driver
 *****************************************/
module "efs_csi" {
  source        = "./addons/efs_csi"
  count         = try(local.addons["efs_csi"].enable, false) ? 1 : 0
  cluster_name  = data.aws_eks_cluster.eks.id
  oidc_provider = data.terraform_remote_state.eks.outputs.oidc_provider
  region        = var.region
  name          = coalesce(try(local.addons["efs_csi"].name, null), "efs-csi-driver")
  namespace     = coalesce(try(local.addons["efs_csi"].namespace, null), "kube-addons")
  helmversion   = coalesce(try(local.addons["efs_csi"].version, null), "3.1.5")
  release       = coalesce(try(local.addons["efs_csi"].property.release, null), "v2.1.4")
  efs_id        = data.terraform_remote_state.efs.outputs.efs_id
}


/******************************************
	External DNS
 *****************************************/
module "external_dns" {
  source             = "./addons/external_dns"
  count              = try(local.addons["external_dns"].enable, false) ? 1 : 0
  cluster_name       = data.aws_eks_cluster.eks.id
  oidc_provider      = data.terraform_remote_state.eks.outputs.oidc_provider
  name               = coalesce(try(local.addons["external_dns"].name, null), "external-dns")
  namespace          = coalesce(try(local.addons["external_dns"].namespace, null), "kube-addons")
  helmversion        = coalesce(try(local.addons["external_dns"].version, null), "8.6.0")
  public_dns_enable  = coalesce(try(local.addons["external_dns"].property.public_dns_enable, null), true)
  public_saname      = coalesce(try(local.addons["external_dns"].property.public_saname, null), "external-dns-public")
  public_zone        = coalesce(try(local.addons["external_dns"].property.public_zone, null), "demo-live")
  public_domain      = coalesce(try(local.addons["external_dns"].property.public_domain, null), "demo.live")
  public_policy      = coalesce(try(local.addons["external_dns"].property.public_policy, null), "upsert-only")
  public_role        = try(local.addons["external_dns"].property.public_role, null)
  private_dns_enable = coalesce(try(local.addons["external_dns"].property.private_dns_enable, null), true)
  private_saname     = coalesce(try(local.addons["external_dns"].property.private_saname, null), "external-dns-private")
  private_zone       = coalesce(try(local.addons["external_dns"].property.private_zone, null), "demo-int")
  private_domain     = coalesce(try(local.addons["external_dns"].property.private_domain, null), "demo.int")
  private_policy     = coalesce(try(local.addons["external_dns"].property.private_policy, null), "upsert-only")
  private_role       = try(local.addons["external_dns"].property.private_role, null)
}

# =============================================================================
# Karpenter Addon
# =============================================================================
# Deploy Karpenter for advanced node provisioning and scaling

module "karpenter" {
  source           = "./addons/karpenter"
  count            = try(local.addons["karpenter"].enable, false) ? 1 : 0
  cluster_name     = data.aws_eks_cluster.eks.id
  cluster_endpoint = data.terraform_remote_state.eks.outputs.cluster_endpoint
  region           = var.region
  name             = coalesce(try(local.addons["karpenter"].name, null), "karpenter")
  namespace        = coalesce(try(local.addons["karpenter"].namespace, null), "kube-addons")
  helmversion      = coalesce(try(local.addons["karpenter"].version, null), "1.6.2")
  tags             = merge(local.tags, local.tags)
}

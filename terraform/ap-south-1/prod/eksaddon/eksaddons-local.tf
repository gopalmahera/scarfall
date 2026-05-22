locals {
  addons = {
    alb_controller = {
      enable    = true
      name      = "aws-load-balancer-controller"
      namespace = "kube-addon"
      version   = "1.11.0"
      property = {
        release = "v2.11.0"
      }
    },
    kubernetes_dashboard = {
      enable    = true
      name      = "kubernetes-dashboard"
      namespace = "kube-addon"
      version   = "7.10.1"
      property = {
        alb_name        = "scarefall-int"
        url             = "k8s-prod.scarfallbr.com"
        external        = false
        certificate_arn = "arn:aws:acm:ap-south-1:321133955826:certificate/659e3dc6-1883-424b-87f4-069d4b0879b7"
      }
    },
    cluster_autoscaler = {
      enable    = true
      name      = "cluster-autoscaler"
      namespace = "kube-addon"
      version   = "9.45.1"
    },
    ebs_csi = {
      enable    = true
      name      = "ebs-csi-driver"
      namespace = "kube-addon"
      version   = "2.38.1"
      property = {
        release = "v1.38.1"
      }
    },
    efs_csi = {
      enable    = false
      name      = "efs-csi-driver"
      namespace = "kube-addon"
      version   = "3.1.5"
      property = {
        release = "v2.1.4"
      }
    },
    external_dns = {
      enable    = true
      name      = "external-dns"
      namespace = "kube-addon"
      version   = "8.5.1"
      property = {
        public_dns_enable  = true
        public_saname      = "external-dns-prod-public"
        public_zone        = "Z07548938CQEY68J2PLF"
        public_domain      = "scarfallbr.com"
        public_policy      = "sync"
        public_role        = "arn:aws:iam::300906349855:role/pod-role-prod-ap-south-1-kube-addon-external-dns-prod-public"
        private_dns_enable = true
        private_saname     = "external-dns-prod-private"
        private_zone       = "Z10046573RGYPS6YNY8HO"
        private_domain     = "scarfallbr.infra"
        private_policy     = "sync"
        private_role       = "arn:aws:iam::300906349855:role/pod-role-prod-ap-south-1-kube-addon-external-dns-prod-private"
      }
    },
    karpenter = {
      enable    = true
      name      = "karpenter"
      namespace = "kube-addon"
      version   = "1.12.0"
    }
  }
}

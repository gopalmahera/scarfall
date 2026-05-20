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
        url             = "k8s-dev.scarfallbr.com"
        external        = false
        certificate_arn = "arn:aws:acm:ap-south-1:148761651852:certificate/5f25b523-689e-408b-98f8-f6f147949178"
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
        public_saname      = "external-dns-dev-public"
        public_zone        = "Z07548938CQEY68J2PLF"
        public_domain      = "scarfallbr.com"
        public_policy      = "sync"
        public_role        = "arn:aws:iam::300906349855:role/pod-role-dev-ap-south-1-kube-addon-external-dns-dev-public"
        private_dns_enable = true
        private_saname     = "external-dns-dev-private"
        private_zone       = "Z10046573RGYPS6YNY8HO"
        private_domain     = "scarfallbr.infra"
        private_policy     = "sync"
        private_role       = "arn:aws:iam::300906349855:role/pod-role-dev-ap-south-1-kube-addon-external-dns-dev-private"
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

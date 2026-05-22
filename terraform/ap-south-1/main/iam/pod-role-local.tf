# Extract unique customer policies along with namespaces from pod_roles
locals {
  oidc_providers = {
    "dev-ap-south-1"  = "oidc.eks.ap-south-1.amazonaws.com/id/E8436D06DBA3CCBBCE3340EA519F26E0"
    "prod-ap-south-1" = "oidc.eks.ap-south-1.amazonaws.com/id/4AB2AE330473921D24553562901E2327"
  }

  pod_roles = {
    external-dns-dev-private  = { enable = true, env = "dev-ap-south-1", namespace = "kube-addon", service_account = ["external-dns-dev-private"], policy = [{ type = "customer", name = "external-dns" }] },
    external-dns-dev-public   = { enable = true, env = "dev-ap-south-1", namespace = "kube-addon", service_account = ["external-dns-dev-public"], policy = [{ type = "customer", name = "external-dns" }] },
    external-dns-prod-private = { enable = true, env = "prod-ap-south-1", namespace = "kube-addon", service_account = ["external-dns-prod-private"], policy = [{ type = "customer", name = "external-dns" }] },
    external-dns-prod-public  = { enable = true, env = "prod-ap-south-1", namespace = "kube-addon", service_account = ["external-dns-prod-public"], policy = [{ type = "customer", name = "external-dns" }] },
    source-controller-dev     = { enable = true, env = "dev-ap-south-1", namespace = "flux-system", service_account = ["source-controller-dev"], policy = [{ type = "customer", name = "source-controller" }] },
    source-controller-prod    = { enable = true, env = "prod-ap-south-1", namespace = "flux-system", service_account = ["source-controller-prod"], policy = [{ type = "customer", name = "source-controller" }] },
  }
}

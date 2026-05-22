locals {
  pod_roles = {
    # Keda Service Role
    loki      = { enable = true, namespace = "monitoring", service_account = ["loki"], policy = [{ type = "customer", name = "loki" }] },
    warm-pool = { enable = true, namespace = "sf2-admin", service_account = ["warm-pool"], policy = [{ type = "customer", name = "gameplay-warm-pool" }] },
  }
}

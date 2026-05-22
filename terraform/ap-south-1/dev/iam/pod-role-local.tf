locals {
  pod_roles = {
    # Keda Service Role
    loki          = { enable = true, namespace = "monitoring", service_account = ["loki"], policy = [{ type = "customer", name = "loki" }] },
    admin-backend = { enable = true, namespace = "sf2-admin", service_account = ["admin-backend-dev"], policy = [{ type = "customer", name = "admin-backend-dev" }] },
  }
}

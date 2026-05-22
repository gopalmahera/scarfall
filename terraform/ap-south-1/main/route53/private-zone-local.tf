locals {
  private_zone_name = "scarfallbr.infra"
  private_vpc       = data.terraform_remote_state.vpc.outputs.vpc_id
  private_records = {
    "helm-repo" = { type = "CNAME", ttl = 300, records = ["helm-repo.scarfallbr.infra.s3-website.ap-south-1.amazonaws.com"] }
  }
}

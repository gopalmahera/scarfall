locals {
  public_zone_name = "scarfallbr.com"
  public_vpc       = data.terraform_remote_state.vpc.outputs.vpc_id
  public_records = {
    # "dev-mq"             = { type = "CNAME", ttl = 300, records = ["b-859ca0a1-e7d7-4c7d-851e-ac734cfe601c.mq.ap-south-1.amazonaws.com"] }
    # "dev-redis-adaptor"  = { type = "CNAME", ttl = 300, records = ["abc.ap-south-1.amazonaws.com"] }
    # "dev-redis-database" = { type = "CNAME", ttl = 300, records = ["xyz.ap-south-1.amazonaws.com"] }
  }
}

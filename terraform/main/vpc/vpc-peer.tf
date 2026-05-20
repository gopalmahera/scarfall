resource "aws_vpc_peering_connection" "main_dev" {
  vpc_id        = module.vpc.vpc_id
  peer_owner_id = "148761651852"
  peer_region   = "ap-south-1"
  peer_vpc_id   = "vpc-011aea6bb9ae40a9f"

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "vpc",
    "Name" = "main-dev" }
  )
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "main_dev_public" {
  count                     = length(module.vpc.public_route_table_ids) > 0 ? length(module.vpc.public_route_table_ids) : 0
  route_table_id            = module.vpc.public_route_table_ids[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.main_dev.id
  destination_cidr_block    = "10.60.0.0/16"
}

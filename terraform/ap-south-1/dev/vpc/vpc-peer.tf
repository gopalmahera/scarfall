resource "aws_vpc_peering_connection" "main_dev" {
  vpc_id        = module.vpc.vpc_id
  peer_owner_id = "300906349855"
  peer_region   = "ap-south-1"
  peer_vpc_id   = "vpc-0334ba16cec4acc11"

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "vpc",
    "Name" = "main-dev" }
  )
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "main_dev_public" {
  count                     = length(module.vpc.public_route_table_ids) > 0 ? length(module.vpc.public_route_table_ids) : 0
  route_table_id            = module.vpc.public_route_table_ids[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.main_dev.id
  destination_cidr_block    = "10.50.0.0/16"
}

resource "aws_route" "main_dev_private" {
  count                     = length(module.vpc.private_route_table_ids) > 0 ? length(module.vpc.private_route_table_ids) : 0
  route_table_id            = module.vpc.private_route_table_ids[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.main_dev.id
  destination_cidr_block    = "10.50.0.0/16"
}

resource "aws_route" "main_dev_db" {
  count                     = length(module.vpc.database_route_table_ids) > 0 ? length(module.vpc.database_route_table_ids) : 0
  route_table_id            = module.vpc.database_route_table_ids[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.main_dev.id
  destination_cidr_block    = "10.50.0.0/16"
}

resource "aws_vpc" "this" {
  tags                 = var.tags
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags
}

resource "aws_route" "egress" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "this" {
  count      = length(data.aws_availability_zones.available.names)
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  tags = merge(
    var.tags,
    {
      "Name" = cidrsubnet(var.vpc_cidr, 8, count.index)
    }
  )
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "this" {
  count          = length(aws_subnet.this)
  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_vpc.this.main_route_table_id
}
#######
# VPC #
#######

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = join(" ", ["VPC", var.name])
  }
}

resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name_servers = var.dns
  tags = {
    Name = join(" ", ["DHCP", var.name])
  }
}

resource "aws_vpc_dhcp_options_association" "vpc_dhcp" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}


####################
# PUBLIC RESOURCES #
####################

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = join(" ", ["InternetGateway", var.name])
  }
}

resource "aws_default_route_table" "route_table_public" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = join(" ", ["RouteTablePublic", var.name])
  }
}

resource "aws_subnet" "public_subnet" {
  count      = length(var.public_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet[count.index]
  tags = {
    Name = join(" ", [join(" ", ["PublicSubnet", count.index]), var.name])
  }
}

resource "aws_route_table_association" "route_table_public_subnet" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_default_route_table.route_table_public.id
}


#####################
# PRIVATE RESOURCES #
#####################

resource "aws_subnet" "private_subnet" {
  count      = length(var.private_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet[count.index]
  tags = {
    Name = join(" ", [join(" ", ["PrivateSubnet", count.index]), var.name])
  }
}

resource "aws_eip" "elastic_ip" {
  count      = length(var.nat_association)
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = join(" ", [join(" ", ["ElasticIP", count.index]), var.name])
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.nat_association)
  allocation_id = aws_eip.elastic_ip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = join(" ", [join(" ", ["NATGateway", count.index]), var.name])
  }
}

resource "aws_route_table" "route_table_private" {
  count  = length(var.nat_association)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
  tags = {
    Name = join(" ", [join(" ", ["RouteTablePrivate", count.index]), var.name])
  }
}

locals {

  nat_association = flatten([
    for key, list in var.nat_association : [
      for cidr in list : {
        "subnet"      = aws_subnet.private_subnet[index(aws_subnet.private_subnet.*.cidr_block, cidr)].id
        "route_table" = aws_route_table.route_table_private[key].id
      }
    ]
  ])

}

resource "aws_route_table_association" "route_table_private_subnet" {
  count          = length(local.nat_association)
  subnet_id      = local.nat_association[count.index].subnet
  route_table_id = local.nat_association[count.index].route_table
}

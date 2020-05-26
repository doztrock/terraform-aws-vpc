#######
# VPC #
#######

resource "aws_vpc" "vpc" {
  cidr_block       = var.CIDR
  instance_tenancy = "default"
  tags = {
    Name = join(" - ", ["VPC", var.NAME])
  }
}

resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name_servers = var.DNS
  tags = {
    Name = join(" - ", ["DHCP", var.NAME])
  }
}

resource "aws_vpc_dhcp_options_association" "vpc-dhcp" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}


####################
# PUBLIC RESOURCES #
####################

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = join(" - ", ["InternetGateway", var.NAME])
  }
}

resource "aws_default_route_table" "route-table-public" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = join(" - ", ["RouteTablePublic", var.NAME])
  }
}

resource "aws_subnet" "public-subnet" {
  count      = length(var.PUBLIC-SUBNET)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.PUBLIC-SUBNET[count.index]
  tags = {
    Name = join(" - ", [join(" ", ["PublicSubnet", count.index]), var.NAME])
  }
}

resource "aws_route_table_association" "route-table-public-subnet" {
  count          = length(var.PUBLIC-SUBNET)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_default_route_table.route-table-public.id
}


#####################
# PRIVATE RESOURCES #
#####################

resource "aws_subnet" "private-subnet" {
  count      = length(var.PRIVATE-SUBNET)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.PRIVATE-SUBNET[count.index]
  tags = {
    Name = join(" - ", [join(" ", ["PrivateSubnet", count.index]), var.NAME])
  }
}

resource "aws_eip" "elastic-ip" {
  count      = length(var.NAT)
  vpc        = true
  depends_on = [aws_internet_gateway.internet-gateway]
  tags = {
    Name = join(" - ", [join(" ", ["ElasticIP", count.index]), var.NAME])
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  count         = length(var.NAT)
  allocation_id = aws_eip.elastic-ip[count.index].id
  subnet_id     = aws_subnet.public-subnet[count.index].id
  tags = {
    Name = join(" - ", [join(" ", ["NATGateway", count.index]), var.NAME])
  }
}

resource "aws_route_table" "route-table-private" {
  count  = length(var.NAT)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway[count.index].id
  }
  tags = {
    Name = join(" - ", [join(" ", ["RouteTablePrivate", count.index]), var.NAME])
  }
}

locals {

  NAT-ASSOCIATION = flatten([
    for KEY, LIST in var.NAT : [
      for CIDR in LIST : {
        "subnet"      = aws_subnet.private-subnet[index(aws_subnet.private-subnet.*.cidr_block, CIDR)].id
        "route-table" = aws_route_table.route-table-private[KEY].id
      }
    ]
  ])

}

resource "aws_route_table_association" "route-table-private-subnet" {
  count          = length(local.NAT-ASSOCIATION)
  subnet_id      = local.NAT-ASSOCIATION[count.index].subnet
  route_table_id = local.NAT-ASSOCIATION[count.index].route-table
}

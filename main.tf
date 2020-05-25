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

resource "aws_subnet" "subnet-public" {
  count      = length(var.PUBLIC-SUBNET)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.PUBLIC-SUBNET[count.index]
  tags = {
    Name = join(" - ", [join(" ", ["PublicSubnet", count.index]), var.NAME])
  }
}

resource "aws_route_table_association" "route-table-subnet-public" {
  count          = length(var.PUBLIC-SUBNET)
  subnet_id      = aws_subnet.subnet-public[count.index].id
  route_table_id = aws_default_route_table.route-table-public.id
}

/*
 * ELASTIC IP
 */
resource "aws_eip" "elastic-ip" {
  count      = length(var.NAT)
  vpc        = true
  depends_on = [aws_internet_gateway.internet-gateway]
  tags = {
    Name = join(" - ", [join(" ", ["IP", count.index]), var.NAME])
  }
}

/*
 * NAT Gateway
 */
resource "aws_nat_gateway" "nat-gateway" {
  count         = length(var.NAT)
  allocation_id = aws_eip.elastic-ip[count.index].id
  subnet_id     = aws_subnet.subnet-public[count.index].id
  tags = {
    Name = join(" - ", [join(" ", ["NAT", count.index]), var.NAME])
  }
}

/*
 * ROUTE TABLE (PRIVATE)
 */
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

/*
 * SUBNET (PRIVATE)
 */
resource "aws_subnet" "subnet-private" {
  for_each   = var.NAT
  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value
  tags = {
    Name = join(" - ", [join(" ", ["PrivateSubnet", each.key]), var.NAME])
  }
}

/*
 * SUBNET ASSOCIATION (PRIVATE)
 */
resource "aws_route_table_association" "route-table-subnet-private" {
  count          = length(var.NAT)
  subnet_id      = aws_subnet.subnet-private[count.index].id
  route_table_id = aws_route_table.route-table-private[count.index].id
}

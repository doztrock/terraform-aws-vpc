output "vpc_id" {
  description = "Identificador asignado a la VPC."
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "Bloque CIDR asignado a la VPC."
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnet" {
  description = "Listado de subredes publicas."
  value       = aws_subnet.public_subnet
}

output "private_subnet" {
  description = "Listado de subredes privadas."
  value       = aws_subnet.private_subnet
}

output "elastic_ip" {
  description = "Listado de direcciones IP."
  value       = aws_eip.elastic_ip
}

output "nat_gateway" {
  description = "Listado de NAT."
  value       = aws_nat_gateway.nat_gateway
}

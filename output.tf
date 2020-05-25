output "VPC-ID" {
  description = "Identificador asignado a la VPC."
  value       = aws_vpc.vpc.id
}

output "PUBLIC-SUBNET" {
  description = "Listado de subredes publicas."
  value       = aws_subnet.public-subnet
}

output "PRIVATE-SUBNET" {
  description = "Listado de subredes privadas."
  value       = aws_subnet.private-subnet
}

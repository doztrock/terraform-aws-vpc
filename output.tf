output "VPC-ID" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "PUBLIC-SUBNET" {
  description = "VPC Public Subnet List"
  value       = aws_subnet.subnet-public
}

output "PRIVATE-SUBNET" {
  description = "VPC Private Subnet List"
  value = aws_subnet.subnet-public
}

output "VPC-ID" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "PUBLIC-SUBNET" {
  description = "VPC Public Subnet List"
  count       = length(aws_subnet.subnet-public)
  value       = aws_subnet.subnet-public[count.index].id
}

output "PRIVATE-SUBNET" {
  description = "VPC Private Subnet List"
  count       = length(aws_subnet.subnet-public)
  value = aws_subnet.subnet-public[count.index].id
}

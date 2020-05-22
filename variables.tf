variable "NAME" {
  description = "VPC Name"
}

variable "CIDR" {
  description = "VPC CIDR Block"
}

variable "PUBLIC-SUBNET" {
  description = "VPC Public Subnet"
  default     = []
}

variable "PRIVATE-SUBNET" {
  description = "VPC Private Subnet"
  default     = []
}

variable "NAT" {
  description = "VPC NAT"
  default     = {}
}

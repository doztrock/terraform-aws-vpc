variable "name" {
  description = "Nombre de la VPC."
}

variable "dns" {
  description = "DNS asignados a la VPC."
  default = [
    "208.67.222.222",
    "8.8.8.8",
    "208.67.220.220",
    "8.8.4.4"
  ]
}

variable "cidr" {
  description = "Bloque CIDR asignado a la VPC"
}

variable "public_subnet" {
  description = "Listado de subredes publicas."
  default     = []
}

variable "private_subnet" {
  description = "Listado de subredes privadas."
  default     = []
}

variable "nat_association" {
  description = "Listado de subredes asociadas por NAT."
  default     = []
}

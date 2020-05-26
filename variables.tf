variable "NAME" {
  description = "Nombre de la VPC."
}

variable "DNS" {
  description = "DNS asignados a la VPC."
  default = [
    "208.67.222.222",
    "8.8.8.8",
    "208.67.220.220",
    "8.8.4.4"
  ]
}

variable "CIDR" {
  description = "Bloque CIDR asignado a la VPC"
}

variable "PUBLIC-SUBNET" {
  description = "Listado de subredes publicas."
  default     = []
}

variable "PRIVATE-SUBNET" {
  description = "Listado de subredes privadas."
  default     = []
}

variable "NAT" {
  description = "Listado de subredes asociadas por NAT."
  default     = []
}

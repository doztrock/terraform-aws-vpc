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

variable "NAT0" {
  description = "VPC NAT Gateway #1"
  default     = []
}

variable "NAT1" {
  description = "VPC NAT Gateway #2"
  default     = []
}

variable "NAT2" {
  description = "VPC NAT Gateway #3"
  default     = []
}

variable "NAT3" {
  description = "VPC NAT Gateway #4"
  default     = []
}

variable "NAT4" {
  description = "VPC NAT Gateway #5"
  default     = []
}

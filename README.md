# terraform-aws-vpc

Modulo de terraform creado con la intencion de facilitar la generacion de una VPC junto a sus respectivos recursos.

Listado de recursos:

- VPC
- ROUTE TABLE
- SUBNET
- INTERNET GATEWAY
- NAT GATEWAY

Se puede decidir crear entre crear una VPC con redes publicas e incluso agregar a estas redes privadas que se configuren con una ruta hacia un NAT.

### Ejemplo #1

Creacion de una VPC con 4 subredes publicas y 2 subredes privadas a su vez vinculadas con sus respectivos NAT.

```java
provider "aws" {
  region = "us-east-1"
}

module "VPC" {
  NAME   = "MyVPC"
  CIDR   = "10.20.0.0/16"
  PUBLIC-SUBNET = [
    "10.20.0.0/24",
    "10.20.1.0/24",
    "10.20.2.0/24",
    "10.20.3.0/24"
  ]
  PRIVATE-SUBNET = [
    "10.20.10.0/24",
    "10.20.11.0/24",
    "10.20.12.0/24",
    "10.20.13.0/24"
  ]
  NAT = {
    0 = "10.20.10.0/24"
    1 = "10.20.11.0/24"
  }
}
```

### Ejemplo #2

Creacion de una VPC con 2 subredes publicas sin subredes privadas.

```java
provider "aws" {
  region = "us-east-1"
}

module "VPC" {
  NAME   = "MyVPC"
  CIDR   = "10.20.0.0/16"
  PUBLIC-SUBNET = [
    "10.20.0.0/24",
    "10.20.1.0/24"
  ]
}
```

### Ejemplo #3

Creacion de una VPC sin subredes.

```java
provider "aws" {
  region = "us-east-1"
}

module "VPC" {
  NAME   = "MyVPC"
  CIDR   = "10.20.0.0/16"
}
```

### Ejemplo #4

Creacion de una VPC con 2 subredes publicas y 2 subredes privadas.

```java
provider "aws" {
  region = "us-east-1"
}

module "VPC" {
  NAME   = "MyVPC"
  CIDR   = "10.20.0.0/16"
  PUBLIC-SUBNET = [
    "10.20.0.0/24",
    "10.20.1.0/24"
  ]
  PRIVATE-SUBNET = [
    "10.20.10.0/24",
    "10.20.11.0/24"
  ]
}
```

NOTA: La variable **NAME** se adjuntara a todos los recursos creados bajo la VPC para permitir una mejor identificacion de los mismo al momento de ingresar a Amazon Web Services.
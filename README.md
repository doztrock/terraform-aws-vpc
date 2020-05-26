# terraform-aws-vpc

Modulo de terraform creado con la intencion de facilitar la generacion de una VPC junto a sus respectivos recursos.

Listado de recursos:

- VPC
- INTERNET GATEWAY
- SUBNET
- ROUTE TABLE
- NAT GATEWAY *(opcional)*

Se puede decidir crear entre crear una VPC con redes publicas e incluso agregar redes privadas con o sin conexion saliente por un NAT.

### Ejemplo #1

Creacion de una VPC con **4 subredes publicas** y **5 subredes privadas** a su vez vinculadas con sus  **3  NAT** a los que se asocian diferentes subredes.

```java
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "app.terraform.io/sundevs/vpc/aws"
  version = "1.0.2"
  NAME    = "MyVPC"
  CIDR    = "10.1.0.0/16"
  PUBLIC-SUBNET = [
    "10.1.0.0/24",
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]
  PRIVATE-SUBNET = [
    "10.1.100.0/24",
    "10.1.101.0/24",
    "10.1.102.0/24",
    "10.1.103.0/24",
    "10.1.104.0/24"
  ]
  NAT = [
    [
      "10.1.100.0/24",
      "10.1.101.0/24"
    ],
    [
      "10.1.102.0/24",
      "10.1.103.0/24"
    ],
    [
      "10.1.104.0/24"
    ]
  ]
}
```

### Ejemplo #2

Creacion de una VPC con **2 subredes publicas sin subredes privadas**.

```java
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "app.terraform.io/sundevs/vpc/aws"
  version = "1.0.2"
  NAME    = "MyVPC"
  CIDR    = "10.1.0.0/16"
  PUBLIC-SUBNET = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]
}
```

### Ejemplo #3

Creacion de una VPC **sin subredes**.

```java
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "app.terraform.io/sundevs/vpc/aws"
  version = "1.0.2"
  NAME    = "MyVPC"
  CIDR    = "10.1.0.0/16"
}
```

### Ejemplo #4

Creacion de una VPC con **2 subredes publicas** y **2 subredes privadas sin NAT**.

```java
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "app.terraform.io/sundevs/vpc/aws"
  version = "1.0.2"
  NAME    = "MyVPC"
  CIDR    = "10.1.0.0/16"
  PUBLIC-SUBNET = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]
  PRIVATE-SUBNET = [
    "10.1.100.0/24",
    "10.1.101.0/24"
  ]
}
```

*La variable **NAME** se adjuntara a todos los recursos creados bajo la VPC para permitir una mejor identificacion de los mismo al momento de ingresar a *Amazon Web Services*.

**La cantidad de redes publicas no debe ser **inferior** a la cantidad de __NAT__ a crear, esto para permitir una mejor distribucion de todos los recursos en diferentes zonas de disponibilidad.

***Cabe aclarar que siempre es **necesario** contar con **subredes privadas** para poder crear **NAT**.
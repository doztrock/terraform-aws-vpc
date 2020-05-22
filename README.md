provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/ivanbotero/.aws/credentials"
  profile                 = "sundevs-terraform"
}

module "VPCModule" {
  source = "./modules/VPC/"
  NAME   = "VPCSunDevs"
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

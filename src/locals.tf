locals {
availability_zones      = ["eu-west-2a", "eu-west-2b"]
vpc_cidr                = "10.0.0.0/16"
public_subnet_cidrs     = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidrs    = ["10.0.3.0/24", "10.0.4.0/24"]
key_name                = "kk_webserver"
}
terraform {
  required_version      = "~> 1.12.2"
  
  required_providers {
    aws                 = {
      source            = "hashicorp/aws"
      version           = "~> 6.2.0"
    }
  }
  # Run init/plan/apply with "backend" commented-out (ueses local backend) to provision Resources (Bucket, Table)
  # Then uncomment "backend" and run init, apply after Resources have been created (uses AWS)
  #backend "s3" {
  #  bucket              = "git-workflows-tf-state"
  #  key                 = "tf-infra/terraform.tfstate"
  #  region              = "eu-west-2"
  #  dynamodb_table      = "terraform-state-locking"
  #  encrypt             = true
  #}

}

provider "aws" {
  region                = "eu-west-2"
}

module "tf-state" {
  source                = "./modules/tf-state"
  bucket_name           = "git-workflows-tf-state"
}

module "vpc-infra" {
  source                = "./modules/vpc"

  # VPC Input Vars
  vpc_cidr              = local.vpc_cidr
  availability_zones    = local.availability_zones
  public_subnet_cidrs   = local.public_subnet_cidrs
  private_subnet_cidrs  = local.private_subnet_cidrs
}

module "db-infra" {
  source                = "./modules/db"

  # RDS Input Vars
  vpc_id                = module.vpc-infra.kk_vpc_id
  kk_private_subnets    = module.vpc-infra.kk_private_subnets
  private_subnet_cidrs  = local.private_subnet_cidrs

  db_az                 = local.availability_zones[0]
  db_name               = "kkDatabaseInstance"
  db_username           = var.db_username
  db_user_password      = var.db_user_password
}

module "webserver-infra" {
  source                = "./modules/webserver"

  # Web Server (EC2 Instances) Input Vars
  vpc_id                = module.vpc-infra.kk_vpc_id
  public_subnets        = module.vpc-infra.kk_public_subnets
  public_subnet_cidrs   = local.public_subnet_cidrs
}

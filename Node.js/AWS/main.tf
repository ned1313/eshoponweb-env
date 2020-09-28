############################
# VARIABLES
############################

variable "region" {
    type = string
    default = "us-east-1"
}

variable "name" {
    type =string
    default = "crud"
}

variable "vpc_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

############################
# PROVIDERS
############################

provider "aws" {
    profile = "gigaom"
    version = "~> 2.0"
    region  = var.region
}

#############################################################################
# DATA SOURCES
#############################################################################

data "aws_availability_zones" "azs" {}

data "http" "my_ip" {
    url = "http://ifconfig.me"
}

############################
# RESOURCES
############################

## VPC


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~>2.0"

  name = "${var.name}-nodejs"
  cidr = var.vpc_cidr_range

  azs             = slice(data.aws_availability_zones.azs.names, 0, 2)
  public_subnets  = var.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false
  map_public_ip_on_launch = true
  enable_dns_hostnames  = true

  tags = {
  }
}

## Security groups

# LB SG

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow traffic for ELB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# DOC DB Security Group

resource "aws_security_group" "docdb_sg" {
  name        = "docdb_sg"
  description = "Allow traffic for ELB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow Mongo"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_range]
  }

  egress {
    description = "Allow Mongo"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}



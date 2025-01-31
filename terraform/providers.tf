terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

# Pasadena (Client + Bastion)
provider "aws" {
  region = "us-west-2"
  alias  = "pasadena"
}

# Spain (Server0)
provider "aws" {
  region = "eu-south-2"
  alias  = "spain"
}

# Canberra (Server1)
provider "aws" {
  region = "ap-southeast-2"
  alias  = "canberra"
}

# Barstow (Server2)
provider "aws" {
  region = "us-west-1"
  alias  = "barstow"
}
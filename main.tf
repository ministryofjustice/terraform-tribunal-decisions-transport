provider "aws" {
  features {}
  region  = var.region
  alias   = "default"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "dts-legacy-codebuild-terraform"
    key            = "tribunals-transport.tfstate"
    encrypt        = true
    region         = "eu-west-2"
    dynamodb_table = "tribunals-transport-tf-lock"
  }
}

locals {
  name    = "tf-tribunals-${var.application_name}-${var.environment}"
  region  = var.region  
  tags = {
    Name = local.name   
    Info = "Created by terraform scripts for tribunal decisions"
  }
}

data "aws_vpc" "vpc" {
  id = "vpc-05f89596ed3934580"
}

data "aws_security_group" "security_group" {
  id = "sg-073d19e19de0dbfb9"
}
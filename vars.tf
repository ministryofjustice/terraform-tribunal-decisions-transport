variable "region" {
  default = "eu-west-2" 
}

variable "application_name" {
  #description = "(Required)Tribunal Decisions application name\nTransport Tribunal\nLands Chamber Tribunal"
  default = "transport"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "domain_name" {
  default = "tf-tribunals-transport.dev.net.tp.dsd.io"
}

variable "aws_route53_zone" {
  default = "tribunals-transport-test.com"
}

variable "aws_route53_record_name" {
  default = "terraform.net.tp.dsd.io"
}

#variable "vpc_id" {}

variable "environment" {
  type = string
  #default = "development"
}

variable app_db_name {
  default = "transport11"
}  

variable app_db_login_name {
  default = "transport"
}  
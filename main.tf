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

resource "aws_instance" "instance" {
  ami           = "ami-05bfd03d0709e3ecb"
  instance_type = "t2.micro"
  key_name      = "terraform-tribunals"
  subnet_id = data.aws_subnet.subnet2a.id
  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    Name = "dts-legacy-tribunals-${var.application_name}-${var.environment}"
  }

  user_data = "${file("user-data.init")}"
}

resource "aws_security_group" "security_group" {
  name = "tf-tribunals-${var.application_name}-${var.environment}-sg"
  vpc_id      = data.aws_vpc.selected.id
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["209.35.92.199/32"]
  }
}

variable "http_port" {
  description = "The port the web erver will be listening"
  type        = number
  default     = 8080
}

output "public_ip" {
  value       = aws_instance.instance.public_ip
  description = "The public IP of the web server"
}

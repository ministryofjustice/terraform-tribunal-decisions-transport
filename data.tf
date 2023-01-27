##### Use the dts-legacy VPC and its private subnets for the RDS creation
data "aws_vpc" "selected" {
  id = "vpc-09a110bcd6ccc856c" #dts-legacy-vpc
}

data "aws_subnet" "subnet2a" {
  #id = "subnet-049b91f09a6ff9579" #dts-legacy-subnet-public3-eu-west-2a
  id = "subnet-06d8877eeca2fcc26" #dts-legacy-subnet-private3-eu-west-2a
}

data "aws_subnet" "subnet2b" {
  #id = "subnet-06d8877eeca2fcc26" #dts-legacy-subnet-public3-eu-west-2b
  id = "subnet-0ed08d9793ddfd6cc" #dts-legacy-subnet-private3-eu-west-2b
}

data "aws_subnet" "subnet2c" {
  #id = "subnet-0ed08d9793ddfd6cc" #dts-legacy-subnet-public3-eu-west-2c
  id = "subnet-049b91f09a6ff9579" #dts-legacy-subnet-private3-eu-west-2c
}

data "aws_db_instance" "database" {
  db_instance_identifier = "tf-tribunals-dev"
}
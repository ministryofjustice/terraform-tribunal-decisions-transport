##### Use the dts-legacy VPC and its private subnets for the RDS creation
data "aws_vpc" "selected" {
  id = "vpc-09a110bcd6ccc856c" #dts-legacy-vpc
}

data "aws_subnet" "public_subnet2a" {
  id = "subnet-049b91f09a6ff9579" #dts-legacy-subnet-public1-eu-west-2a
}

data "aws_subnet" "public_subnet2b" {
  id = "subnet-06d8877eeca2fcc26" #dts-legacy-subnet-public2-eu-west-2b
}

data "aws_subnet" "public_subnet2c" {
  id = "subnet-0ed08d9793ddfd6cc" #dts-legacy-subnet-public3-eu-west-2c
}

data "aws_subnet" "private_subnet2a" {
  id = "subnet-0367222bc33a31ca5" #dts-legacy-subnet-private1-eu-west-2a
}

data "aws_subnet" "private_subnet2b" {
  id = "subnet-0575451086b4af5de" #dts-legacy-subnet-private2-eu-west-2b
}

data "aws_subnet" "private_subnet2c" {
  id = "subnet-023f52b93d5da85d6" #dts-legacy-subnet-private3-eu-west-2c
}


data "aws_db_instance" "database" {
  db_instance_identifier = "tf-tribunals-dev"
}

data "aws_secretsmanager_secret" "rds-secrets" {
  arn = "arn:aws:secretsmanager:eu-west-2:207640118376:secret:tf-tribunals-dev-credentials-3Qvv1c"
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds-secrets.id
}

data "aws_secretsmanager_secret" "source-db-secrets" {
  arn = "arn:aws:secretsmanager:eu-west-2:207640118376:secret:tribunals-source-db-credentials-dev-z8FxOM"
}

data "aws_secretsmanager_secret_version" "source-db" {
  secret_id = data.aws_secretsmanager_secret.source-db-secrets.id
}
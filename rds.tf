terraform {
  required_providers {
    mssql = {
      source = "betr-io/mssql"
      version = "0.1.0"
    }
  }
}

provider "mssql" {
  debug = "false"
}

resource "null_resource" "setup_db" {
  depends_on = [data.aws_db_instance.database] #wait for the db to be ready

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "ifconfig -a; chmod +x ./setup-mssql.sh; ./setup-mssql.sh"

    environment = {
      DB_URL = data.aws_db_instance.database.address
      USER_NAME = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["username"]
      PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["password"]
    }
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

 resource "random_password" "password" {
  length  = 16
  special = true //Only printable ASCII characters besides '/', '@', '"', ' ' may be used.
  override_special = "!#$%&*()-_=+[]{}<>:?" 
}

data "aws_secretsmanager_secret" "db-secrets" {
  arn = "arn:aws:secretsmanager:eu-west-2:207640118376:secret:tf-tribunals-dev-credentials-Hxjqy2"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.db-secrets.id
}


resource "mssql_user" "db-user" {
  server {
    host = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["host"]    
    port = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["port"]
    login {
      username = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["username"]
      password = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["password"]
    }
  }

  database  = "master"
  username  = "transport"
  password  = random_password.password.result 

  roles     = ["db_owner"]
}


 resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "tf-tribunals-${var.application_name}-${var.environment}-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = <<EOF
{
  "username": "${mssql_user.db-user.username}",
  "password": "${mssql_user.db-user.password}",  
  "host": "${mssql_user.db-user.server[0].host}",
  "port": ${mssql_user.db-user.server[0].port}, 
  "database_name": "transport"
}
EOF
}
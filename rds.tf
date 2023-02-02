resource "random_password" "new_password" {
  length  = 16
  special = true //Only printable ASCII characters besides '/', '@', '"', ' ' may be used.
  override_special = "!#$%&*()-_=+[]{}<>:?" 
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
      NEW_DB_NAME = var.app_db_name
      NEW_USER_NAME = var.app_db_login_name
      NEW_PASSWORD = random_password.new_password.result
    }
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}


data "aws_secretsmanager_secret" "db-secrets" {
  arn = "arn:aws:secretsmanager:eu-west-2:207640118376:secret:tf-tribunals-dev-credentials-Hxjqy2"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.db-secrets.id
}

 resource "aws_secretsmanager_secret" "db_credentials" {
  name = "tf-tribunals-${var.application_name}-${var.environment}-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = <<EOF
{
  "username": var.app_db_login_name,
  "password": random_password.new_password.result,  
  "host": data.aws_db_instance.database.address,  
  "database_name": var.app_db_name
}
EOF
}
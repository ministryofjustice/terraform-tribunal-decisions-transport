resource "null_resource" "setup_db" {
  depends_on = [data.aws_db_instance.database] #wait for the db to be ready

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "ifconfig -a; chmod +x ./setup-mssql.sh; ./setup-mssql.sh"

    environment = {
      DB_URL = data.aws_db_instance.database.address
    }
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}
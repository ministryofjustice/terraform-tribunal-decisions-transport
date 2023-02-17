

provider "aws" {
  region     = "eu-west-1"
  access_key = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["dms_source_account_access_key"]
  secret_key = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["dms_source_account_secret_key"]
  alias   = "mojdsd"
}

module "dms" {
  source = "github.com/ministryofjustice/terraform-tribunals-dms?ref=master"

  db_instance                       = data.aws_db_instance.database
  db_hostname                       = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["host"]
  db_password                       = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"]
  db_username                       = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["username"]
  dms_source_db_password            = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["password"]
  dms_source_db_username            = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["username"]
  dms_source_db_hostname            = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["host"]
  dms_replication_instance          = module.dms.dms_replication_instance
  region                            = var.region
  dms_source_account_access_key     = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["dms_source_account_access_key"]
  dms_source_account_secret_key     = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["dms_source_account_secret_key"]
  application_name                  = var.application_name
  source_db_name                    = "Transport"
  target_db_name                    = "transport"
  environment                       = var.environment
  ec2_instance_id                   = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["ec2-instance-id"]
}

resource "aws_security_group" "dms_access_rule" {
  name = "dms_access_rule"
  description = "allow dms access to the database"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    description = "Allow DMS to connect to source database"
    cidr_blocks = [module.dms.dms_replication_instance]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  provider = aws.mojdsd

 }

 resource "null_resource" "setup_source_ec2_security_group" {
  depends_on = [module.dms.dms_replication_instance]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = "ifconfig -a; chmod +x ./setup-security-group.sh; ./setup-security-group.sh"   

    environment = {
      DMS_SECURITY_GROUP            = aws_security_group.dms_access_rule.id
      EC2_INSTANCE_ID               = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["ec2-instance-id"]
      DMS_SOURCE_ACCOUNT_ACCESS_KEY = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["dms_source_account_access_key"]
      DMS_SOURCE_ACCOUNT_SECRET_KEY = jsondecode(data.aws_secretsmanager_secret_version.source-db.secret_string)["dms_source_account_secret_key"]

    }
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}
module "elasticBeanStalk" {
    source = "github.com/ministryofjustice/terraform-tribunals-elasticbeanstalk.git?ref=main"  

certificate                      = module.dns_Ssl.certificate
application_name                 = local.name
instance_type                    = var.instance_type
vpc_id                           = data.aws_vpc.vpc.id
environment                      = var.environment
vpc_security_group_id            = data.aws_security_group.security_group.id
subnet_ids                       = ["subnet-06e5a811ce6dd646a", "subnet-0d50a5070be6d014e", "subnet-09243bfdb0fdf847e"]

}
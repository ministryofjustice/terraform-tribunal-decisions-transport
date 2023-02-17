# module "elasticBeanStalk" {
#     source = "github.com/ministryofjustice/terraform-tribunals-elasticbeanstalk.git?ref=main"  

# certificate                      = module.dns_Ssl.certificate
# application_name                 = local.name
# instance_type                    = var.instance_type
# vpc_id                           = data.aws_vpc.selected.id
# environment                      = var.environment
# #vpc_security_group_id            = aws_security_group.security_group.id
# subnet_ids                       = [data.aws_subnet.subnet2a.id, data.aws_subnet.subnet2b.id, data.aws_subnet.subnet2c.id]

# }
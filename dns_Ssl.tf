module "dns_Ssl" {
   source = "github.com/ministryofjustice/terraform-tribunals-dnsssl.git?ref=main"

  domain_name               = var.domain_name
  cname                     = module.elasticBeanStalk.cname
  zone                      = module.elasticBeanStalk.zone
  aws_route53_zone          = var.aws_route53_zone
  aws_route53_record_name   = var.aws_route53_record_name                       
}
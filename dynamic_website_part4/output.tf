output "alb_dns_endpoint" {
  value = module.alb.alb_dns_endpoint
}

output "name_servers" {
  value = module.route53.name_servers
}
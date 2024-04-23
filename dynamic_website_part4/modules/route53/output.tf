output "hosted_zone_id" {
  value = aws_route53_zone.hosted_zone.id
}

output "name_servers" {
  value = aws_route53_zone.hosted_zone.name_servers
}
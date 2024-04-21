# Create Hosted Zone In Route 53
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}


## Create  Route 53 records
resource "aws_route53_record" "websiteurl" {
  name    = var.endpoint
  zone_id = aws_route53_zone.hosted_zone.id
  type    = "A"

  alias {
    name                   = var.alb_dns_endpoint
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

}


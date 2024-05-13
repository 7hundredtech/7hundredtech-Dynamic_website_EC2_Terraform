output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "alb_sg_arn" {
  value = aws_security_group.alb_sg.arn
}

output "website_sg_arn" {
  value = aws_security_group.ecs_sg.arn
}
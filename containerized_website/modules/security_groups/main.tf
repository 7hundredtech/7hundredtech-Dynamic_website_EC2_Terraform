# Apllication Load Balancer Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "enable http/https access on port 80 and 443 respectively"
  vpc_id      = var.vpc_id


ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

tags   = {
    Name = "alb_sg"
  }

 }
resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "enable http/https access on port 80/443 through alb_sg/and access on port 22 via ssh sg"
  vpc_id      = var.vpc_id


ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }
ingress {
    description      = "http access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }
 ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  } 

   egress {
    from_port        = 0
    to_port          = 0    
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }
tags   = {
    Name = "ecs_sg"
  }
}
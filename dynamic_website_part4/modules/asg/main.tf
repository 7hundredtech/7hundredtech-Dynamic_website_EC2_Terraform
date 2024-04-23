# create a launch template
# terraform aws launch template
resource "aws_launch_template" "website_lt" {
    description   = "launch Template for website server"
  name          = "${var.project_name}-website_lt"
  image_id      = data.aws_ami.amazon_linux_2.image_id
  instance_type = var.instance_type
  key_name      = var.key_name


  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [var.website_sg_id, var.alb_sg_id]

  user_data =filebase64("${path.module}/script.sh")
}

# create auto scaling group
# terraform aws autoscaling group
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  name                = "${var.project_name}-asg"
  health_check_type   = "ELB"

  launch_template {
    name    = aws_launch_template.website_lt.name
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}"
    propagate_at_launch = true
  }

}

# attach auto scaling group to alb target group
resource "aws_autoscaling_attachment" "asg_alb_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = var.alb_tg_arn
  elb = var.alb_id
}


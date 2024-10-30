resource "aws_autoscaling_group" "front_end-ASG" {
  name                      = "ASG-frontend"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.public_subnets.*.id
  target_group_arns = [aws_lb_target_group.front_end.arn]

  launch_template {
    id      = aws_launch_template.front_end.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "Web_Server"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_group" "back_end-ASG" {
  name                      = "ASG-backend"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.private_subnets.*.id
  target_group_arns = [aws_lb_target_group.back_end.arn]
  

  launch_template {
    id      = aws_launch_template.back_end.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "App_Server"
    propagate_at_launch = true
  }
}
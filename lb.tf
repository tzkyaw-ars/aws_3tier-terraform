 resource "aws_lb" "front_end" {
  name               = "frontend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_frontend-sg.id]
  subnets            = aws_subnet.public_subnets.*.id

  enable_deletion_protection = false
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_lb_target_group" "front_end" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 30
    matcher = "200"
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
  }
}

 resource "aws_lb" "back_end" {
  name               = "backend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_backend-sg.id]
  subnets            = aws_subnet.private_subnets.*.id

  enable_deletion_protection = false
}

resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.back_end.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.back_end.arn
  }
}

resource "aws_lb_target_group" "back_end" {
  name     = "backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher            = "200"
    path               = "/"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }
}

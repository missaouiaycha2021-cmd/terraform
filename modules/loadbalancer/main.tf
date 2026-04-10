resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.dashboard_subnet_az1, var.dashboard_subnet_az2]
  security_groups    = [var.frontend_sg]
}

resource "aws_lb_target_group" "dashboard_tg" {
  name     = "dashboard-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard_tg.arn
  }
}
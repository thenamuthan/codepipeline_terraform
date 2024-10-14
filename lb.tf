#create load balancer for ecs
resource "aws_lb" "demo" {
  name                             = "demo"
  subnets                          = module.vpc.public_subnets
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"
}

resource "aws_lb_listener" "demo" {
  load_balancer_arn = aws_lb.demo.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-blue.arn
  }
  lifecycle {
    ignore_changes = [default_action]
  }
}

resource "aws_lb_target_group" "demo-blue" {
  name                 = "demo-http-blue"
  port                 = "3000"
  protocol             = "TCP"
  vpc_id               = module.vpc.vpc_id
  target_type          = "ip"
  deregistration_delay = 30
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}
resource "aws_lb_target_group" "demo-green" {
  name                 = "demo-http-green"
  port                 = "3000"
  protocol             = "TCP"
  vpc_id               = module.vpc.vpc_id
  target_type          = "ip"
  deregistration_delay = 30
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}
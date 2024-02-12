# creating ALB
resource "aws_lb" "application-lb" {
  name               = "nit-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [aws_default_subnet.public-subnet-1.id, aws_default_subnet.public-subnet-2.id]
  security_groups    = [aws_security_group.load-balancer.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "nit-alb"
  }
}

# target group
resource "aws_lb_target_group" "target-group" {
  name        = "nit-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_default_vpc.default.id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.ec2-cluster.id
  lb_target_group_arn    = aws_lb_target_group.target-group.arn
}


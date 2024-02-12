resource "aws_autoscaling_group" "ec2-cluster" {
  name                 = "myserver_auto_scaling_group"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ec2.name
  vpc_zone_identifier  = [aws_default_subnet.public-subnet-1.id, aws_default_subnet.public-subnet-2.id]
  target_group_arns    = [aws_lb_target_group.target-group.arn]
}
resource "aws_security_group" "load-balancer" {
  name        = "load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "myserver_firewall" {
  name = "web-server"
  description = "Allows inbound access from the ALB only"
  vpc_id = aws_default_vpc.default.id
    dynamic "ingress"{
        for_each = [22, 80, 443]
        iterator = port
        content {
          from_port = port.value
          to_port = port.value
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        
    }
    
    ingress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = [aws_security_group.load-balancer.id]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
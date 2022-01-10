resource "aws_alb" "application_load_balancer" {
  name               = "test-lb-tf"
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    "${aws_subnet.web_app_subnet_a.id}",
    "${aws_subnet.web_app_subnet_b.id}"
  ]
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.webapp_vpc.id
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


resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.webapp_vpc.id
  health_check {
    matcher = "200,301,302"
    path = "/"
  }
  depends_on = [
    "aws_alb.application_load_balancer"
  ]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.application_load_balancer.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
  }
}

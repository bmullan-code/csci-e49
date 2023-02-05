resource "aws_lb" "alb" {  
  name            = "${var.prefix}-alb"  
  load_balancer_type = "application"
  subnets         = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]
  security_groups = [aws_security_group.securitygroup_alb.id]
  internal        = false
}

resource "aws_lb_listener" "alb_listener" {  
  load_balancer_arn = "${aws_lb.alb.arn}"  
  port              = "443"  
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${aws_iam_server_certificate.cert.arn}"
  
  default_action {    
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    type             = "forward"  
  }
}  

resource "aws_lb_target_group" "alb_target_group" {  
  name     = "${var.prefix}-alb-tg"  
  port     = "80"
  protocol = "HTTP"  
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/"
    protocol = "HTTP"
    port = 80
    unhealthy_threshold = 3
    healthy_threshold = 3
    matcher = "200-499"
  }  
}

resource "aws_lb_target_group_attachment" "ws1" {
  target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  target_id        = "${aws_instance.webserver1.id}"  
  port             = 80
}

resource "aws_lb_target_group_attachment" "ws2" {
  target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  target_id        = "${aws_instance.webserver2.id}"  
  port             = 80
}

resource "aws_lb" "this" {
  name               = var.lb_name
  load_balancer_type = "application"
  security_groups    = var.alb_sg_list
  subnets            = var.subnets_id_list
  enable_http2       = true
  ip_address_type    = "ipv4"
  tags               = var.tags
}

resource "aws_lb_listener" "plain_http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "secured_http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "It works!"
      status_code  = "200"
    }
  }
}
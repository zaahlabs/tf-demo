
# ====================
# ALB and target group
# ====================

# target group
resource "aws_alb_target_group" "challenge-tgp" {
  name        = "challenge-tgp"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

# register instance1
resource "aws_alb_target_group_attachment" "albtarget-instance1" {
  target_group_arn = aws_alb_target_group.challenge-tgp.arn
  target_id        = var.instance1_id
  port             = 80
}

# register instance2
resource "aws_alb_target_group_attachment" "albtarget-instance2" {
  target_group_arn = aws_alb_target_group.challenge-tgp.arn
  target_id        = var.instance2_id
  port             = 80
}


# alb
resource "aws_alb" "challenge-alb" {
  name               = "challenge-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb]
  subnets = [
    var.public_subnet1,
    var.public_subnet2
  ]
}

# listener
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.challenge-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.challenge-tgp.arn
  }
}

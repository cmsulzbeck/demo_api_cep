resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name     = each.value.name
  port     = each.value.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = each.value.health_check_path
    matcher             = each.value.health_check_matcher
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, {
    Name = each.value.name
  })
}

locals {
  target_attachments = flatten([
    for group_key, group in var.target_groups : [
      for instance_index, instance_id in group.instance_ids : {
        key         = "${group_key}-${instance_index}"
        group_key   = group_key
        instance_id = instance_id
        port        = group.port
      }
    ]
  ])
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = {
    for attachment in local.target_attachments : attachment.key => attachment
  }

  target_group_arn = aws_lb_target_group.this[each.value.group_key].arn
  target_id        = each.value.instance_id
  port             = each.value.port
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[var.active_target_group].arn
  }
}

locals {
  events = merge([for cp in local.cap_modules : {for i, event in lookup(cp.outputs, "events", []) : "cap_${cp.id}_${i}" => event}]...)
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = local.events

  arn      = local.cluster_arn
  rule     = each.value.rule_name
  role_arn = each.value.role_arn
  input    = each.value.input

  ecs_target {
    tags                   = local.tags
    task_count             = 1
    task_definition_arn    = aws_ecs_task_definition.this.arn
    launch_type            = "FARGATE"
    enable_execute_command = true

    network_configuration {
      subnets          = local.private_subnet_ids
      assign_public_ip = false
      security_groups  = [aws_security_group.this.id]
    }
  }
}

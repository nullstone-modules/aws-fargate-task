data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_version = data.ns_app_env.this.version
}

locals {
  app_metadata = tomap({
    // Inject app metadata into capabilities here (e.g. security_group_id, role_name)
    security_group_id   = aws_security_group.this.id
    role_name           = aws_iam_role.task.name
    main_container      = local.main_container_name
    service_port        = 0
    log_group_name      = module.logs.name
    internal_subdomain  = ""
    task_definition_arn = aws_ecs_task_definition.this.arn
    launch_type         = "FARGATE"
  })
}

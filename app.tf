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
    security_group_id    = aws_security_group.this.id
    subnet_ids           = join(",", local.private_subnet_ids)
    role_name            = aws_iam_role.task.name
    role_arn             = aws_iam_role.task.arn
    execution_role_name  = aws_iam_role.execution.name
    execution_role_arn   = aws_iam_role.execution.arn
    main_container       = local.main_container_name
    service_port         = 0
    log_group_name       = module.logs.name
    internal_subdomain   = ""
    task_definition_name = local.resource_name
    launch_type          = "FARGATE"
  })
}

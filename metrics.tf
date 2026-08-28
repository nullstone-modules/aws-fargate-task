locals {
  task_dims = tomap({
    "ClusterName"          = local.cluster_name
    "TaskDefinitionFamily" = local.resource_name
  })

  metrics_mappings = concat(local.base_metrics, local.event_metrics, local.cap_metrics)

  cap_metrics_defs = lookup(local.capabilities, "metrics", [])
  cap_metrics = [
    for m in local.cap_metrics_defs : {
      name = m.name
      type = m.type
      unit = m.unit

      mappings = {
        for metric_id, mapping in jsondecode(lookup(m, "mappings", "{}")) : metric_id => {
          account_id        = mapping.account_id
          dimensions        = mapping.dimensions
          stat              = lookup(mapping, "stat", null)
          namespace         = lookup(mapping, "namespace", null)
          metric_name       = lookup(mapping, "metric_name", null)
          expression        = lookup(mapping, "expression", null)
          hide_from_results = lookup(mapping, "hide_from_results", null)
        }
      }
    }
  ]

  # FailedInvocations counts launches EventBridge could not start (e.g. bad task definition), not task failures.
  event_metrics = length(local.events) > 0 ? [
    {
      name = "invocations"
      type = "invocations"
      unit = "count"

      mappings = merge([
        for key, event in local.events : {
          "runs_${replace(key, "/[^a-zA-Z0-9_]/", "_")}" = {
            account_id  = local.account_id
            stat        = "Sum"
            namespace   = "AWS/Events"
            metric_name = "Invocations"
            dimensions  = tomap({ "RuleName" = event.rule_name })
          }
          "launch_failures_${replace(key, "/[^a-zA-Z0-9_]/", "_")}" = {
            account_id  = local.account_id
            stat        = "Sum"
            namespace   = "AWS/Events"
            metric_name = "FailedInvocations"
            dimensions  = tomap({ "RuleName" = event.rule_name })
          }
        }
      ]...)
    }
  ] : []

  base_metrics = [
    {
      # Container Insights emits one sample per running task per minute;
      # SampleCount normalized by period = average concurrent tasks.
      name = "app/running_tasks"
      type = "generic"
      unit = "tasks"

      mappings = {
        task_samples = {
          account_id        = local.account_id
          stat              = "SampleCount"
          namespace         = "ECS/ContainerInsights"
          metric_name       = "CpuUtilized"
          dimensions        = local.task_dims
          hide_from_results = true
        }
        tasks_running = {
          account_id = local.account_id
          dimensions = {}
          expression = "task_samples / (PERIOD(task_samples) / 60)"
        }
      }
    },
    {
      # One sample = one task-minute of runtime; duration proxy since ECS has no per-run duration metric.
      name = "app/compute_time"
      type = "generic"
      unit = "task-minutes"

      mappings = {
        compute_minutes = {
          account_id  = local.account_id
          stat        = "SampleCount"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuUtilized"
          dimensions  = local.task_dims
        }
      }
    },
    {
      name = "app/cpu"
      type = "usage"
      unit = "vCPU"

      mappings = {
        cpu_reserved = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuReserved"
          dimensions  = local.task_dims
        }
        cpu_average = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuUtilized"
          dimensions  = local.task_dims
        }
        cpu_min = {
          account_id  = local.account_id
          stat        = "Minimum"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuUtilized"
          dimensions  = local.task_dims
        }
        cpu_max = {
          account_id  = local.account_id
          stat        = "Maximum"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuUtilized"
          dimensions  = local.task_dims
        }
      }
    },
    {
      name = "app/memory"
      type = "usage"
      unit = "MiB"

      mappings = {
        memory_reserved = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "ECS/ContainerInsights"
          metric_name = "MemoryReserved"
          dimensions  = local.task_dims
        }
        memory_average = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "ECS/ContainerInsights"
          metric_name = "MemoryUtilized"
          dimensions  = local.task_dims
        }
        memory_min = {
          account_id  = local.account_id
          stat        = "Minimum"
          namespace   = "ECS/ContainerInsights"
          metric_name = "MemoryUtilized"
          dimensions  = local.task_dims
        }
        memory_max = {
          account_id  = local.account_id
          stat        = "Maximum"
          namespace   = "ECS/ContainerInsights"
          metric_name = "MemoryUtilized"
          dimensions  = local.task_dims
        }
      }
    }
  ]
}

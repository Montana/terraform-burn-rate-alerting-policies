resource "datadog_monitor" "slow_burn_rate" {
  name = "${var.service_name} ${var.environment} - Error Rate SLO [${var.slo}, ${local.slow_burn_rate}x]"

  type = "slo alert"

  query = <<-EOT
burn_rate("${module.error_rate_slo.id}").over("${local.slow_time_window}").long_window("${local.slow_window_long}").short_window("${local.slow_window_short}") > ${local.slow_burn_rate}
EOT

  message = templatefile("${path.module}/message.md", {
    service     = var.service_name
    environment = var.environment
    notify      = local.notify
  })

  tags = concat(["env:${var.environment}", "service:${var.service_name}"], var.tags)

  priority = var.priority_tier

  monitor_thresholds = {
    critical = local.slow_burn_rate
  }
}

resource "google_monitoring_alert_policy" "istio_service_availability_slo_alert" {
  count        = length(var.istio_services)
  display_name = "${var.istio_services[count.index].service_name} Availability Alert Policy"
  combiner     = "AND"
  conditions {
    display_name = "SLO burn rate alert for availability SLO with a threshold of ${var.istio_services[count.index].availability_burn_rate}"
    condition_threshold {

      # This filter alerts on burn rate over the past 60 minutes
      # The service is defined by the unique Istio string that is automatically created
      filter          = "select_slo_burn_rate(\"projects/${var.project_id}/services/canonical-ist:proj-${var.project_number}-default-${var.istio_services[count.index].service_id}/serviceLevelObjectives/${google_monitoring_slo.istio_service_availability_slo[count.index].slo_id}\", 60m)"
      threshold_value = var.istio_services[count.index].availability_burn_rate
      comparison      = "COMPARISON_GT"
      duration        = "60s"
    }
  }
  documentation {
    content   = "Availability SLO burn for the ${var.istio_services[count.index].service_name} for the past 60m exceeded ${var.istio_services[count.index].availability_burn_rate}x the acceptable budget burn rate. The service is returning less OK responses than desired. Consider viewing the service logs or custom dashboard to retrieve more information or adjust the values for the SLO and error budget."
    mime_type = "text/markdown"
  }
}

# Create another alerting policy, this time on the SLO for latency for the Istio service.
# Alerts on error budget burn rate.
resource "google_monitoring_alert_policy" "istio_service_latency_slo_alert" {
  count        = length(var.istio_services)
  display_name = "${var.istio_services[count.index].service_name} Latency Alert Policy"
  combiner     = "AND"
  conditions {
    display_name = "SLO burn rate alert for latency SLO with a threshold of ${var.istio_services[count.index].latency_burn_rate}"
    condition_threshold {
      filter          = "select_slo_burn_rate(\"projects/${var.project_id}/services/canonical-ist:proj-${var.project_number}-default-${var.istio_services[count.index].service_id}/serviceLevelObjectives/${google_monitoring_slo.istio_service_latency_slo[count.index].slo_id}\", 60m)"
      threshold_value = var.istio_services[count.index].availability_burn_rate
      comparison      = "COMPARISON_GT"
      duration        = "60s"
    }
  }
  documentation {
    content   = "Latency SLO burn for the ${var.istio_services[count.index].service_name} for the past 60m exceeded ${var.istio_services[count.index].latency_burn_rate}x the acceptable budget burn rate. The service is responding slower than desired. Consider viewing the service logs or custom dashboard to retrieve more information or adjust the values for the SLO and error budget."
    mime_type = "text/markdown"
  }
}

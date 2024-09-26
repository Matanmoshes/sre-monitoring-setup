output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.web_app_alb.dns_name
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${aws_instance.monitoring_instance.public_ip}:9090"
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "http://${aws_instance.monitoring_instance.public_ip}:3000"
}

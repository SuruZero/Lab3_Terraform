output "vm_external_ip" {
  value = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
}

output "web_url" {
  value = "http://${google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip}:${var.web_port}"
}
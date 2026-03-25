output "vm_external_ip" {
  value = google_compute_instance.vm_lab3.network_interface[0].access_config[0].nat_ip
}

output "service_url" {
  value = "http://${google_compute_instance.vm_lab3.network_interface[0].access_config[0].nat_ip}:8081"
}
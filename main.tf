# 1. Налаштування провайдера Google
provider "google" {
  project = "zubochistka"
  region  = "europe-west3"
}

# 2. Створення VPC 
resource "google_compute_network" "vpc_lab3" {
  name                    = "vpc-veluchko-vitalii-02"
  auto_create_subnetworks = false
}

# 3. Створення підмережі 
resource "google_compute_subnetwork" "subnet_a" {
  name          = "subnet-a-veluchko-vitalii-02"
  ip_cidr_range = "10.2.10.0/24"
  region        = "europe-west3"
  network       = google_compute_network.vpc_lab3.id
}

# 4. Налаштування Firewall 
resource "google_compute_firewall" "allow_ssh_web" {
  name    = "fw-allow-ssh-web-8081"
  network = google_compute_network.vpc_lab3.name

  allow {
    protocol = "tcp"
    ports    = ["22", "8081"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# 5. Віртуальна машина 
resource "google_compute_instance" "vm_lab3" {
  name         = "vm-veluchko-vitalii-02"
  machine_type = "e2-micro"
  zone         = "europe-west3-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_lab3.name
    subnetwork = google_compute_subnetwork.subnet_a.name
    access_config {} 
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    mkdir -p /var/www/site_02
    echo "<h1>Lab 3 - Terraform - Vitalii Veluchko - Variant 02</h1>" > /var/www/site_02/index.html
    sed -i 's/Listen 80/Listen 8081/' /etc/apache2/ports.conf
    printf "<VirtualHost *:8081>\n  ServerName var2.local\n  DocumentRoot /var/www/site_02\n  <Directory /var/www/site_02>\n    Require all granted\n  </Directory>\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf
    systemctl restart apache2
  EOF

  labels = {
    surname = "veluchko"
    name    = "vitalii"
    variant = "02"
  }
}

# 8. Вихідні дані (Outputs)
output "vm_name" {
  value = google_compute_instance.vm_lab3.name
}

output "vm_external_ip" {
  # Використовуємо nat_ip замість assigned_external_ip
  value = google_compute_instance.vm_lab3.network_interface[0].access_config[0].nat_ip
}

output "service_url" {
  # Використовуємо nat_ip для формування посилання
  value = "http://${google_compute_instance.vm_lab3.network_interface[0].access_config[0].nat_ip}:8081"
}
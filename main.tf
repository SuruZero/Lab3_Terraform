# 1. Глобальні теги (Labels у GCP)
locals {
  common_labels = {
    owner   = var.surname
    project = "lab3"
    variant = var.variant
  }
}

# 2. Virtual Private Cloud
resource "google_compute_network" "main_vpc" {
  name                    = "vpc-${var.surname}-${var.variant}"
  auto_create_subnetworks = false
}

# 3. Підмережі у різних зонах (згідно з варіантом 10.2.10.0 та 10.2.20.0)
resource "google_compute_subnetwork" "subnet_a" {
  name          = "subnet-a-${var.variant}"
  ip_cidr_range = var.subnet_a_cidr # 10.2.10.0/24
  region        = var.region
  network       = google_compute_network.main_vpc.id
}

resource "google_compute_subnetwork" "subnet_b" {
  name          = "subnet-b-${var.variant}"
  ip_cidr_range = var.subnet_b_cidr # 10.2.20.0/24
  region        = var.region
  network       = google_compute_network.main_vpc.id
}

# 4. Налаштування безпеки (Firewall)
resource "google_compute_firewall" "web_firewall" {
  name    = "fw-allow-web-${var.variant}"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22", "${var.web_port}"] # SSH та порт 8081
  }
  source_ranges = ["0.0.0.0/0"]
}

# 5. Динамічний пошук образу (Ubuntu 24.04 LTS)
data "google_compute_image" "ubuntu_2404" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}

# 6. Розгортання інстансу ВМ
resource "google_compute_instance" "web_server" {
  name         = "vm-${var.surname}-${var.variant}"
  machine_type = "e2-micro"
  zone         = var.zone_a

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_2404.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_a.id
    access_config {} # Надає зовнішню IP (Аналог Internet Gateway)
  }

  # 7. Передача скрипта ініціалізації через templatefile (Крок 3.5)
  metadata_startup_script = templatefile("bootstrap.sh", {
    variant      = var.variant,
    student_name = "${var.name} ${var.surname}",
    port         = var.web_port,
    server_name  = "var2.local",
    doc_root     = "/var/www/site_02"
  })

  labels = local.common_labels
}
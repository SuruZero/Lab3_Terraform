variable "project_id" { type = string }
variable "region"     { default = "europe-west3" }
variable "zone_a"     { default = "europe-west3-a" }
variable "zone_b"     { default = "europe-west3-b" }
variable "surname"    { type = string }
variable "name"       { type = string }
variable "variant"    { default = "02" }

variable "vpc_cidr"      { default = "10.2.0.0/16" }
variable "subnet_a_cidr" { default = "10.2.10.0/24" }
variable "subnet_b_cidr" { default = "10.2.20.0/24" }
variable "web_port"      { default = 8081 }
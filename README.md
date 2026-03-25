# Lab 3: Infrastructure as Code (IaC) with Terraform
**Student:** Vitalii Veluchko  
**Variant:** 02

## Description
This project automates the deployment of a VPC network, subnets, and a virtual machine with an Apache web server on Google Cloud Platform using Terraform.

## Prerequisites
- Terraform v1.14.7+
- Google Cloud SDK (gcloud)
- Active GCP Project: `zubochistka`

## Usage Instructions
1. **Initialize the project:**
   `terraform init`
2. **Review the execution plan:**
   `terraform plan`
3. **Deploy infrastructure:**
   `terraform apply`
4. **Clean up resources:**
   `terraform destroy`
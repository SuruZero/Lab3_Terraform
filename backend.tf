terraform {
  backend "gcs" {
    bucket = "tf-state-lab3-veluchko-vitalii-02"
    prefix = "env/dev/var-02.tfstate"
  }
}
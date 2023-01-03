terraform {
  backend "s3" {
    bucket                      = "cvdz-tf"
    key                         = "terraform-docker-k3s.tfstate"
    region                      = "fr-par"
    endpoint                    = "https://s3.fr-par.scw.cloud"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}

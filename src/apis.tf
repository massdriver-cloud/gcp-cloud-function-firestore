module "apis" {
  source = "../../../provisioners/terraform/modules/gcp-apis"
  services = [
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com"
  ]
}

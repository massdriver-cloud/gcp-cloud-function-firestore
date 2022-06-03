# To provision a Cloud Function, code needs to be deployed
# this creates a GCS bucket and places an
# application shell zip file in it to act as a placeholder.
# Currently, there's no intention of overwriting this
# and the users application code will be deployed via another means

resource "google_storage_bucket" "main" {
  name     = var.md_metadata.name_prefix
  labels   = var.md_metadata.default_tags
  location = local.gcp_region
}

data "archive_file" "appfiles" {
  type        = "zip"
  source_file = "${path.module}/files/shell-app/index.js"
  output_path = "${path.module}/files/index.zip"
}

resource "google_storage_bucket_object" "main" {
  name   = "index.zip"
  bucket = google_storage_bucket.main.name
  source = data.archive_file.appfiles.output_path
}

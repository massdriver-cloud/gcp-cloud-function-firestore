locals {
  data_infrastructure = {
    function_url = google_cloudfunctions_function.main.https_trigger_url
    grn          = google_cloudfunctions_function.main.id
  }
  data_security = {
  }

  artifact_cloud_function = {
    data = {
      infrastructure = local.data_infrastructure
      security       = local.data_security
    }
    specs = {
      gcp = {
        project = google_cloudfunctions_function.main.project
        region  = google_cloudfunctions_function.main.region
      }
    }
  }
}

resource "massdriver_artifact" "cloud_function" {
  field    = "cloud_function"
  name     = "GCP Cloud Function Firestore ${var.md_metadata.name_prefix} (${google_cloudfunctions_function.main.id})"
  artifact = jsonencode(local.artifact_cloud_function)
}

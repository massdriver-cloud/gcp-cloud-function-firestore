locals {
  runtime = module.cloud_functions.runtime
  event_type_human_to_enum = {
    "Document Create"                    = "providers/cloud.firestore/eventTypes/document.create"
    "Document Update"                    = "providers/cloud.firestore/eventTypes/document.update"
    "Document Delete"                    = "providers/cloud.firestore/eventTypes/document.delete"
    "Document Create, Update, or Delete" = "providers/cloud.firestore/eventTypes/document.write"
  }
  event_type = lookup(local.event_type_human_to_enum, var.firestore_trigger, "")
}

module "cloud_functions" {
  source  = "github.com/massdriver-cloud/terraform-modules//google-cloud-function?ref=9201b9f"
  runtime = var.cloud_function_configuration.runtime
}

resource "google_cloudfunctions_function" "main" {
  name                  = var.md_metadata.name_prefix
  labels                = var.md_metadata.default_tags
  runtime               = local.runtime
  entry_point           = var.cloud_function_configuration.entrypoint
  available_memory_mb   = var.cloud_function_configuration.memory_mb
  min_instances         = var.cloud_function_configuration.minimum_instances
  max_instances         = var.cloud_function_configuration.maximum_instances
  source_archive_bucket = google_storage_bucket.main.name
  source_archive_object = google_storage_bucket_object.main.name

  # not exposed only to make the bundle "simpler"
  # default: 60  (s)
  # max    : 540 (s)
  timeout = 120

  event_trigger {
    # https://cloud.google.com/functions/docs/calling/cloud-firestore#event_types
    event_type = local.event_type
    resource   = "projects/${var.firestore.data.infrastructure.grn}/databases/(default)/documents/${var.document_path}"
    failure_policy {
      retry = false
    }
  }

  depends_on = [
    module.apis
  ]
}

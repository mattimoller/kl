# Adds Firebase to the existing GCP project (idempotent — calls AddFirebase).
resource "google_firebase_project" "default" {
  provider = google-beta

  depends_on = [google_project_service.enabled]
}

# Custom hosting site at klrunning.web.app. The project also has a default
# site at mathias-privat.web.app that we don't use.
resource "google_firebase_hosting_site" "klrunning" {
  provider = google-beta

  project = var.project_id
  site_id = var.firebase_site_id

  depends_on = [google_firebase_project.default]
}

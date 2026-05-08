# user_project_override + billing_project ensure API calls bill against
# our project rather than gcloud's quota project — same trap that bit us
# during the billing console diagnosis. Without this, Firebase/Cloud
# Domains calls can fail with USER_PROJECT_DENIED depending on how the
# operator's gcloud is configured.

provider "google" {
  project               = var.project_id
  region                = var.region
  user_project_override = true
  billing_project       = var.project_id
}

provider "google-beta" {
  project               = var.project_id
  region                = var.region
  user_project_override = true
  billing_project       = var.project_id
}

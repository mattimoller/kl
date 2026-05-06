# Workload Identity Federation: lets GitHub Actions impersonate a GCP
# service account using short-lived OIDC tokens, with no long-lived
# service-account keys in GitHub secrets.
#
# attribute_condition restricts which OIDC tokens this provider trusts.
# Without it, *any* GitHub repo's workflow could mint tokens against our
# pool. The principalSet IAM binding below adds a second wall — only
# tokens whose `assertion.repository` equals our repo can impersonate
# the deploy SA.

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions"
  description               = "WIF for GitHub Actions deploys"

  depends_on = [google_project_service.enabled]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub OIDC"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository == \"${var.github_repo}\""

  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com"
    allowed_audiences = []
  }
}

resource "google_service_account" "deploy" {
  account_id   = "github-deploy"
  display_name = "GitHub Actions Deploy"
  description  = "Impersonated by GitHub Actions via WIF to deploy Firebase Hosting"
}

resource "google_service_account_iam_member" "deploy_wif_user" {
  service_account_id = google_service_account.deploy.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_repo}"
}

# Just enough for `firebase deploy --only hosting` and preview channels.
resource "google_project_iam_member" "deploy_firebase_hosting" {
  project = var.project_id
  role    = "roles/firebasehosting.admin"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}

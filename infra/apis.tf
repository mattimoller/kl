# disable_on_destroy = false: never disable APIs on `terraform destroy`.
# Disabling APIs cascades into hard-to-recover states (deleted resources,
# lost configurations); we'd rather leak APIs than break a teardown.

locals {
  enabled_apis = toset([
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "firebase.googleapis.com",
    "firebasehosting.googleapis.com",
    "dns.googleapis.com",
    "domains.googleapis.com",
  ])
}

resource "google_project_service" "enabled" {
  for_each = local.enabled_apis

  service = each.key

  disable_on_destroy         = false
  disable_dependent_services = false
}

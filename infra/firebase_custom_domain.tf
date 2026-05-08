# Registers klrunning.com as a custom domain on the klrunning Hosting site.
# Firebase verifies ownership by polling the apex A/AAAA records defined in
# dns_records.tf and provisions a managed SSL certificate once they resolve
# correctly. Verification + cert can take from a few minutes to a few hours;
# `wait_dns_verification = false` lets `terraform apply` return immediately
# instead of blocking on it.
#
# Inspect `host_state` and `cert.state` post-apply to see progress, e.g.
#   terraform state show google_firebase_hosting_custom_domain.klrunning_com

resource "google_firebase_hosting_custom_domain" "klrunning_com" {
  provider = google-beta

  project         = var.project_id
  site_id         = google_firebase_hosting_site.klrunning.site_id
  custom_domain   = var.domain
  cert_preference = "GROUPED"

  wait_dns_verification = false

  depends_on = [google_project_service.enabled]
}

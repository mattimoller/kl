# Registers klrunning.no as a custom domain on the same Hosting site as
# klrunning.com, configured to 301-redirect every request to the .com.
# The .no apex is owned by a third party who manages its DNS at his own
# registrar (no Cloud DNS zone here). After `terraform apply`, inspect
#
#   terraform state show google_firebase_hosting_custom_domain.klrunning_no
#
# and read `required_dns_updates.desired` for the exact A + TXT records
# to hand to the .no owner. Expected values:
#
#   A     klrunning.no.   199.36.158.100
#   TXT   klrunning.no.   "hosting-site=klrunning"
#
# Once those resolve, Firebase issues a Let's Encrypt cert for klrunning.no
# and starts serving the 301 redirect to klrunning.com.

resource "google_firebase_hosting_custom_domain" "klrunning_no" {
  provider = google-beta

  project         = var.project_id
  site_id         = google_firebase_hosting_site.klrunning.site_id
  custom_domain   = "klrunning.no"
  redirect_target = var.domain
  cert_preference = "GROUPED"

  wait_dns_verification = false

  depends_on = [google_project_service.enabled]
}

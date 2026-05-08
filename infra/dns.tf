# Public Cloud DNS zone for klrunning.com. Records are added in PR #5
# alongside the Firebase Hosting custom-domain wiring; this PR creates the
# zone only so we have nameservers to swap onto the Cloud Domains
# registration in the cutover.

resource "google_dns_managed_zone" "klrunning" {
  name        = replace(var.domain, ".", "-")
  dns_name    = "${var.domain}."
  description = "Public zone for ${var.domain}"
  visibility  = "public"

  depends_on = [google_project_service.enabled]
}

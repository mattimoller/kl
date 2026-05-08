# Apex A / AAAA records pointing at Firebase Hosting's anycast IPs.
# These IPs are documented at
# https://firebase.google.com/docs/hosting/custom-domain — stable but not
# guaranteed forever. If verification fails after apply, inspect
# `google_firebase_hosting_custom_domain.klrunning_com.required_dns_updates`
# for the records Firebase actually wants and update the rrdatas below.
#
# No CNAME for the apex (apex CNAMEs are spec-illegal). A subdomain like
# www.klrunning.com could be added later with a CNAME to klrunning.web.app
# if Mathias decides to support it.

resource "google_dns_record_set" "apex_a" {
  managed_zone = google_dns_managed_zone.klrunning.name
  name         = "${var.domain}."
  type         = "A"
  ttl          = 300
  rrdatas      = ["199.36.158.100"]
}

resource "google_dns_record_set" "apex_aaaa" {
  managed_zone = google_dns_managed_zone.klrunning.name
  name         = "${var.domain}."
  type         = "AAAA"
  ttl          = 300
  rrdatas      = ["2600:1901:0:38d7::"]
}

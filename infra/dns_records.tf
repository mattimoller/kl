# Apex A record pointing at Firebase Hosting's anycast IP.
# Firebase Hosting terminates IPv6 at Google's edge and proxies internally,
# so a AAAA record is not needed and in fact causes HOST_CONFLICT during
# cert provisioning (Firebase sets required_action=REMOVE on it).
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

# Firebase Hosting ownership verification at the apex.
# Without this, the custom-domain resource sits at host_state =
# HOST_UNREACHABLE and ownership_state = OWNERSHIP_UNREACHABLE, which
# Firebase surfaces as a misleading DNS_SERVFAIL error. The verification
# value is "hosting-site=<site_id>" — kept in sync with the Hosting site
# resource via the variable rather than hardcoded.
resource "google_dns_record_set" "apex_txt_firebase_verify" {
  managed_zone = google_dns_managed_zone.klrunning.name
  name         = "${var.domain}."
  type         = "TXT"
  ttl          = 300
  rrdatas      = ["\"hosting-site=${var.firebase_site_id}\""]
}

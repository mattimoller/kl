# Surfaced for use as GitHub Actions secrets/vars in PR #4 (deploy workflow).
# Set after `terraform apply`:
#   gh secret set WIF_PROVIDER       --body "$(terraform -chdir=infra output -raw workload_identity_provider)"
#   gh secret set WIF_SERVICE_ACCOUNT --body "$(terraform -chdir=infra output -raw deploy_service_account_email)"
#   gh variable set FIREBASE_SITE_ID --body "$(terraform -chdir=infra output -raw firebase_hosting_site_id)"

output "workload_identity_provider" {
  description = "Full WIF provider name to plug into google-github-actions/auth"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "deploy_service_account_email" {
  description = "Service account GitHub Actions impersonates to deploy"
  value       = google_service_account.deploy.email
}

output "firebase_hosting_site_id" {
  description = "Firebase Hosting site ID (deploys target this)"
  value       = google_firebase_hosting_site.klrunning.site_id
}

output "dns_name_servers" {
  description = "Cloud DNS nameservers — point Cloud Domains at these in PR #5"
  value       = google_dns_managed_zone.klrunning.name_servers
}

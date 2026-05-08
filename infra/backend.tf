# Remote state in GCS — replaces the local-only setup that lived under
# infra/terraform.tfstate. Two reasons:
#
# 1. State now lives in a single durable location reachable from any
#    machine: home laptop, work laptop, future CI. Whoever runs
#    `terraform init` reads from the same bucket.
# 2. GCS object generation is used as an exclusive lock, so two
#    concurrent `terraform apply` runs can't corrupt state.
#
# The bucket itself is bootstrapped out-of-band (chicken-and-egg: the
# bucket can't be a Terraform-managed resource that uses itself for
# state). Bootstrap once with:
#
#   gcloud storage buckets create gs://mathias-privat-tf-state \
#     --project=mathias-privat \
#     --location=europe-west1 \
#     --uniform-bucket-level-access \
#     --public-access-prevention
#   gcloud storage buckets update gs://mathias-privat-tf-state --versioning
#
# Versioning matters: every state write keeps a prior generation, so a
# botched apply or accidental `terraform state rm` is recoverable.

terraform {
  backend "gcs" {
    bucket = "mathias-privat-tf-state"
    prefix = "klrunning"
  }
}

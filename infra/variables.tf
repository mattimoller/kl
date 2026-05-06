variable "project_id" {
  type        = string
  default     = "mathias-privat"
  description = "GCP project ID hosting all klrunning.com infra"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "Default region for regional resources (Firebase Hosting itself is global)"
}

variable "domain" {
  type        = string
  default     = "klrunning.com"
  description = "Apex domain registered in Cloud Domains"
}

variable "github_repo" {
  type        = string
  default     = "mattimoller/kl"
  description = "GitHub <owner>/<repo> allowed to authenticate via Workload Identity Federation"
}

variable "firebase_site_id" {
  type        = string
  default     = "klrunning"
  description = "Firebase Hosting site ID (becomes <id>.web.app)"
}

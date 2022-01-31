data "google_compute_zones" "available" {
  region = var.region
}

# NOTE: Read SQL file content from backend repository
data "http" "db_migration_tables" {
  url = "https://raw.githubusercontent.com/p-le/test-todoapp-backend/master/migrations/tables.sql"
}

# NOTE: Read ArgoCD Install YAML Online
data "http" "argocd_install" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/${var.argocd_config.target_version}/manifests/install.yaml"
}

data "google_secret_manager_secret_version" "argocd_ssh_public_key" {
  secret = var.argocd_config.public_ssh_key_secret_id
}

data "google_secret_manager_secret_version" "argocd_ssh_private_key" {
  secret = var.argocd_config.private_ssh_key_secret_id
}

data "kubectl_file_documents" "argocd_manifests" {
  content = data.http.argocd_install.body
}

# NOTE: specifiy target zone to create Zonal GKE Cluster
locals {
  target_deploy_zone = data.google_compute_zones.available.names[0]
}

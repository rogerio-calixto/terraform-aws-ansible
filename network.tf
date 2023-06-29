module "main-network" {
  source        = "../terraform-aws-network"
  project       = var.project
  region        = var.region
  subnet_counts = var.subnet_counts
}
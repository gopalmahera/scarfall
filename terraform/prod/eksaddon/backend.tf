terraform {
  backend "s3" {
    bucket         = "scarfall-terraform-state-jhmirn64"
    key            = "eksaddon.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
    profile        = "scarfall-prod"
  }
}
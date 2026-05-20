terraform {
  backend "s3" {
    bucket         = "scarfall-terraform-state-dglhp2g5"
    key            = "sso.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
    profile        = "scarfall-main"
  }
}
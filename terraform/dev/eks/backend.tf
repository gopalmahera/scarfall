terraform {
  backend "s3" {
    bucket         = "scarfall-terraform-state-30rhjmey"
    key            = "eks.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
    profile        = "scarfall-dev"
  }
}
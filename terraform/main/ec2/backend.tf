terraform {
  backend "s3" {
    bucket         = "scarfall-terraform-state-dglhp2g5"
    key            = "ec2.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
    profile        = "scarfall-main"
  }
}
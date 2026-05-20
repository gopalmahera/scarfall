data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "scarfall-terraform-state-jhmirn64"
    region  = "ap-south-1"
    key     = "vpc.tfstate"
    profile = "scarfall-prod"
  }
}

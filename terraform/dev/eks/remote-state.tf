data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "scarfall-terraform-state-30rhjmey"
    region  = "ap-south-1"
    key     = "vpc.tfstate"
    profile = "scarfall-dev"
  }
}

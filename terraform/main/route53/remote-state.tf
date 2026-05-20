data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "scarfall-terraform-state-dglhp2g5"
    region  = "ap-south-1"
    key     = "vpc.tfstate"
    profile = "scarfall-main"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket  = "scarfall-terraform-state-30rhjmey"
    region  = "ap-south-1"
    key     = "eks.tfstate"
    profile = "scarfall-dev"
  }
}

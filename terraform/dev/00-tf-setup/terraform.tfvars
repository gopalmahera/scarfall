aws_profile = "scarfall-dev"
region      = "ap-south-1"

stages = {
  vpc      = { enable = "true", remote = [] },
  eks      = { enable = "true", remote = ["vpc"] },
  eksaddon = { enable = "true", remote = ["vpc", "eks", "efs"] },
  iam      = { enable = "true", remote = ["eks"] },
  s3       = { enable = "true", remote = [] },
}

tags = {
  environment = "dev"
  owner       = "Kalpesh Patel"
  terraform   = "true"
}

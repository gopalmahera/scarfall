aws_profile = "scarfall-prod"
region      = "ap-south-1"

stages = {
  vpc      = { enable = "true", remote = [] },
  eks      = { enable = "true", remote = ["vpc"] },
  eksaddon = { enable = "true", remote = ["vpc", "eks", "efs"] },
  iam      = { enable = "true", remote = ["eks"] },
  s3       = { enable = "true", remote = [] },
}

tags = {
  environment = "prod"
  owner       = "Kalpesh Patel"
  terraform   = "true"
}

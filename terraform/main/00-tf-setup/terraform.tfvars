aws_profile = "scarfall-main"
region      = "ap-south-1"

stages = {
  vpc     = { enable = "true", remote = [] },
  sso     = { enable = "true", remote = [] },
  iam     = { enable = "true", remote = [] },
  ecr     = { enable = "true", remote = [] },
  route53 = { enable = "true", remote = ["vpc"] },
  ec2     = { enable = "true", remote = ["vpc", "route53"] },
}

tags = {
  environment = "main"
  owner       = "Kalpesh Patel"
  terraform   = "true"
}

region = "ap-south-1"

environments = {

  dev = {
    profile = "scarfall-dev"
  }

  main = {
    profile = "scarfall-main"
  }

  prod = {
    profile = "scarfall-prod"
  }
}

stages = {

  # ---------------- MAIN ----------------
  main_vpc     = { enable = true, environment = "main", region = "ap-south-1", folder = "vpc", remote = [] },
  main_iam     = { enable = true, environment = "main", region = "ap-south-1", folder = "iam", remote = [] },
  main_ecr     = { enable = true, environment = "main", region = "ap-south-1", folder = "ecr", remote = [] },
  main_sso     = { enable = true, environment = "main", region = "ap-south-1", folder = "sso", remote = [] },
  main_route53 = { enable = true, environment = "main", region = "ap-south-1", folder = "route53", remote = ["main_vpc"] },
  main_ec2     = { enable = true, environment = "main", region = "ap-south-1", folder = "ec2", remote = ["main_vpc", "main_route53"] },

  # ---------------- DEV ----------------
  dev_vpc      = { enable = true, environment = "dev", region = "ap-south-1", folder = "vpc", remote = [] },
  dev_s3       = { enable = true, environment = "dev", region = "ap-south-1", folder = "s3", remote = [] },
  dev_iam      = { enable = true, environment = "dev", region = "ap-south-1", folder = "iam", remote = [] },
  dev_eks      = { enable = true, environment = "dev", region = "ap-south-1", folder = "eks", remote = ["dev_vpc"] },
  dev_eksaddon = { enable = true, environment = "dev", region = "ap-south-1", folder = "eksaddon", remote = ["dev_vpc", "dev_eks"] },

  # ---------------- PROD ----------------
  prod_vpc       = { enable = true, environment = "prod", region = "ap-south-1", folder = "vpc", remote = [] },
  prod_s3        = { enable = true, environment = "prod", region = "ap-south-1", folder = "s3", remote = [] },
  prod_iam       = { enable = true, environment = "prod", region = "ap-south-1", folder = "iam", remote = ["prod_eks"] },
  prod_eks       = { enable = true, environment = "prod", region = "ap-south-1", folder = "eks", remote = ["prod_vpc"] },
  prod_eksaddons = { enable = true, environment = "prod", region = "ap-south-1", folder = "eksaddon", remote = ["prod_vpc", "prod_eks"] }



}

aws_profile = "scarfall-main"
region      = "ap-south-1"

tags = {
  environment = "main"
  owner       = "Kalpesh Patel"
  terraform   = "true"
}

groups = {
  group-admin        = { enable = true, display_name = "Adminstrator", description = "Adminstrator Access" }
  group-readonly     = { enable = true, display_name = "Readonly", description = "Readonly Access" }
  group-readonlyprod = { enable = true, display_name = "ReadonlyProd", description = "ReadonlyProd Access" }
}

users = {
  "jemish.lakhani"   = { enable = true, display_name = "Jemish Lakhani", first_name = "Jemish", last_name = "Lakhani", email = "jemish@xsquads.com", group = ["group-admin"] }
  "ashish.dhameliya" = { enable = true, display_name = "Ashish Dhameliya", first_name = "Ashish", last_name = "Dhameliya", email = "ashish@xsquads.com", group = ["group-admin"] }
  "nikunj.chaudhari" = { enable = true, display_name = "Nikunj Chaudhari", first_name = "Nikunj", last_name = "Chaudhari", email = "nikunjxsquads@hotmail.com", group = ["group-admin"] }
  "kalpesh.patel"    = { enable = true, display_name = "Kalpesh Patel", first_name = "Kalpesh", last_name = "Patel", email = "kalpesh.br.patel@gmail.com", group = ["group-admin", "group-readonly"] }
  "utsav.patel"      = { enable = true, display_name = "Utsav Patel", first_name = "Utsav", last_name = "Patel", email = "utsav7@gmail.com", group = ["group-readonly"] }
  "kandarp.bhatt"    = { enable = true, display_name = "Kandarp Bhatt", first_name = "Kandarp", last_name = "Bhatt", email = "kandarpbhatt88@gmail.com", group = ["group-readonly"] }
  "hiren.suthar"     = { enable = true, display_name = "Hiren Suthar,", first_name = "Hiren", last_name = "Suthar", email = "hssuthar15@gmail.com", group = ["group-readonly"] }
  "jay.jariwala"     = { enable = true, display_name = "Jay Jariwala", first_name = "Jay", last_name = "Jariwala", email = "jay.jariwala@scarfall.in", group = ["group-readonly"] }
  # "jay.lauffer"      = { enable = true, display_name = "Jay Lauffer", first_name = "Jay", last_name = "Lauffer", email = "jay@blastplus.com", group = ["group-readonly"] }
  "sonu.khobragade" = { enable = true, display_name = "Sonu Khobragade", first_name = "Sonu", last_name = "Khobragade", email = "sonu@mplgaming.com", group = ["group-readonly"] }
  "ashwini.dhekane" = { enable = true, display_name = "Ashwini Dhekane", first_name = "Ashwini", last_name = "Dhekane", email = "ashwinidhekane@blastplus.com", group = ["group-readonly"] }
  "kaustubh.bhoyar" = { enable = true, display_name = "Kaustubh Bhoyar", first_name = "Kaustubh", last_name = "Bhoyar", email = "kb@mplgaming.com", group = ["group-readonly"] }
  "backend"         = { enable = true, display_name = "Backend", first_name = "Backend", last_name = "Xsquads", email = "backend@xsquads.com", group = ["group-readonly"] }
  "kartik.sojitra"  = { enable = true, display_name = "Kartik Sojitra", first_name = "Kartik", last_name = "Sojitra", email = "kartik.sojitra@scarfall.in", group = ["group-readonly"] }
  "rashid.saiyyd"   = { enable = true, display_name = "Rashid Saiyyd", first_name = "Rashid", last_name = "Saiyyd", email = "rashid.saiyyd@scarfall.in", group = ["group-readonlyprod"] }
  "gopal.mahera"    = { enable = true, display_name = "Gopal Mahera", first_name = "Gopal", last_name = "Mahera", email = "gm908071@gmail.com", group = ["group-admin"] }
}

customer_managed_policy = {
}

permission_set = {
  # ReadOnly 
  readonly = {
    name = "ReadOnly-Access", description = "ReadOnly Access", session_duration = "PT12H",
    attachment = [
      { type = "managed", policy = "ReadOnlyAccess" }
    ]
  }

  # Group Admin
  adminstrator = {
    name = "Administrator-Access", description = "Administrator Access", session_duration = "PT12H",
    attachment = [
      { type = "managed", policy = "AdministratorAccess" }
    ]
  }
}

group_account_assignment = {
  group-admin = [
    { permission_set = "adminstrator", account = "management" },
    { permission_set = "adminstrator", account = "dev" },
    { permission_set = "adminstrator", account = "prod" },
  ],
  group-readonly = [
    { permission_set = "readonly", account = "management" },
    { permission_set = "readonly", account = "dev" },
    { permission_set = "readonly", account = "prod" },
  ],
  group-readonlyprod = [
    { permission_set = "readonly", account = "prod" },
  ],
}

locals {
  ecr = {
    "sf2-admin"                    = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
    "sf2-angular"                  = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
    "sf2-instance"                 = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
    "sf2-user"                     = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
    "sf2-agones-gs"                = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
    "sf2-tools/gameplay-warm-pool" = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
    "sf2-user-nest"                = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
    "sf2-assets-management"        = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
    "sf2-demoapi"                  = { enable = "true", crossaccount_allow = true, encryption = { enable = true, kms_key = "" } },
  }
}

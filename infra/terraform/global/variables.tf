 variable  "region"  {
    type               = string
     description  = "Home  region  for  org  management"
    default         =  "us-east-1"
 }

 variable  "org_root_email"  {
    type               = string
     description  = "Root  email  for  AWS  Organizations (management  account)"
 }

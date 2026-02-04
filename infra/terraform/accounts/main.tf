variable  "security_account_email"  { type  =  string  }
variable "logging_account_email"    {  type  = string  }
variable  "shared_account_email"     {  type  =  string }

data  "aws_organizations_organization"  "org" {}

resource  "aws_organizations_account"  "security" {
    name           = "Security"
    email         =  var.security_account_email
   role_name  =  "OrganizationAccountAccessRole"
   parent_id  =  data.aws_organizations_organization.org.roots[0].id
}

resource  "aws_organizations_account"  "logging" {
    name           = "Logging"
    email         =  var.logging_account_email
   role_name  =  "OrganizationAccountAccessRole"
   parent_id  =  data.aws_organizations_organization.org.roots[0].id
}

resource  "aws_organizations_account"  "shared" {
    name           = "SharedServices"
    email         =  var.shared_account_email
   role_name  =  "OrganizationAccountAccessRole"
   parent_id  =  data.aws_organizations_organization.org.roots[0].id
}

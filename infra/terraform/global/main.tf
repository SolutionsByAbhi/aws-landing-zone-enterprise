resource "aws_organizations_organization"  "this"  {
   aws_service_access_principals  =  [
       "cloudtrail.amazonaws.com",
       "config.amazonaws.com",
       "guardduty.amazonaws.com",
       "securityhub.amazonaws.com"
   ]

    feature_set =  "ALL"
}

resource "aws_organizations_organizational_unit"  "security"  {
   name           =  "Security"
   parent_id  =  aws_organizations_organization.this.roots[0].id
}

resource  "aws_organizations_organizational_unit"  "logging"  {
   name           =  "Logging"
   parent_id  =  aws_organizations_organization.this.roots[0].id
}

resource  "aws_organizations_organizational_unit"  "shared"  {
   name           =  "SharedServices"
   parent_id  =  aws_organizations_organization.this.roots[0].id
}

resource  "aws_organizations_organizational_unit"  "workloads" {
    name           = "Workloads"
    parent_id  = aws_organizations_organization.this.roots[0].id
}

module  "scp_guardrails" {
    source  = "../modules/scp"

    org_root_id =  aws_organizations_organization.this.roots[0].id

   deny_regions  =  [
       "ap-south-1",
       "sa-east-1"
   ]

    deny_services =  [
       "aws-portal:*",
       "support:*"
    ]
}

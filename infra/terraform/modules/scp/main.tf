variable  "org_root_id" {
    type  = string
}

variable  "deny_regions" {
    type       =  list(string)
   default  =  []
}

variable  "deny_services"  {
   type       =  list(string)
    default =  []
}

data "aws_iam_policy_document"  "deny_regions"  {
   statement  {
       sid       =  "DenyUnsupportedRegions"
       effect  =  "Deny"

       actions     =  ["*"]
       resources  = ["*"]

       condition  {
           test         = "StringNotEquals"
           variable  =  "aws:RequestedRegion"
          values      = var.deny_regions
       }

       principals  {
           type              =  "*"
          identifiers  =  ["*"]
       }
   }
}

data  "aws_iam_policy_document" "deny_services"  {
    statement {
       sid        = "DenyDisallowedServices"
       effect  =  "Deny"

       actions     =  var.deny_services
       resources  =  ["*"]

       principals  {
           type              =  "*"
           identifiers =  ["*"]
       }
    }
}

resource  "aws_organizations_policy"  "deny_regions" {
    name              =  "DenyUnsupportedRegions"
   description  =  "Deny  use  of regions  outside  approved  list"
   type               = "SERVICE_CONTROL_POLICY"
    content         =  data.aws_iam_policy_document.deny_regions.json
}

resource  "aws_organizations_policy"  "deny_services" {
    name              =  "DenyDisallowedServices"
   description  =  "Deny  use  of disallowed  services"
    type              =  "SERVICE_CONTROL_POLICY"
   content         =  data.aws_iam_policy_document.deny_services.json
}

resource  "aws_organizations_policy_attachment"  "root_regions"  {
   policy_id  =  aws_organizations_policy.deny_regions.id
   target_id  =  var.org_root_id
}

resource  "aws_organizations_policy_attachment"  "root_services"  {
   policy_id  =  aws_organizations_policy.deny_services.id
   target_id  =  var.org_root_id
}

 variable  "logging_account_id"    { type  =  string  }
 variable "security_account_id"  {  type  =  string }
 variable  "member_account_ids"    { type  =  list(string)  }
 variable "region"                          { type  =  string  }
 
provider  "aws"  {
    alias    =  "logging"
    region  =  var.region
 
    assume_role  {
        role_arn  = "arn:aws:iam::${var.logging_account_id}:role/OrganizationAccountAccessRole"
     }
 }

 provider  "aws"  {
    alias    =  "security"
    region  =  var.region

     assume_role  {
        role_arn =  "arn:aws:iam::${var.security_account_id}:role/OrganizationAccountAccessRole"
     }
}
 
 module  "cloudtrail_central"  {
    source       =  "../modules/cloudtrail-central"
    providers  =  {  aws  = aws.logging  }
 
    bucket_name  =  "org-central-cloudtrail-logs"
 }
 
module  "config_aggregator"  {
    source        = "../modules/config-aggregator"
     providers  = {  aws  =  aws.logging  }

     account_ids  = concat([var.logging_account_id,  var.security_account_id],  var.member_account_ids)
 }
 
module  "guardduty"  {
    source        = "../modules/guardduty"
     providers  = {  aws  =  aws.security  }

     member_account_ids  = var.member_account_ids
 }
 
 module  "security_hub" {
     source       =  "../modules/security-hub"
    providers  =  {  aws =  aws.security  }
 
    member_account_ids  =  var.member_account_ids
 }

variable  "workload_account_id" {  type  =  string  }
variable  "region"                         {  type  =  string  }

provider  "aws"  {
   region  =  var.region

   assume_role  {
       role_arn  = "arn:aws:iam::${var.workload_account_id}:role/OrganizationAccountAccessRole"
    }
}

module  "baseline"  {
   source  =  "../../account-baselines/workload-account"

   region  =  var.region
}

module  "app_vpc"  {
   source  =  "../../../infra/terraform/modules/vpc"

    name            =  "app-landing-zone-vpc"
    cidr_block =  "10.20.0.0/16"
    az_count     =  3
}

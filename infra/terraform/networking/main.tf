variable  "shared_account_id"  { type  =  string  }
variable "workload_account_ids"  {
    type =  list(string)
}

provider "aws"  {
    alias   =  "shared"
   region  =  var.region

   assume_role  {
       role_arn  =  "arn:aws:iam::${var.shared_account_id}:role/OrganizationAccountAccessRole"
   }
}

module  "hub_vpc"  {
   source      =  "../modules/vpc"
   providers  =  { aws  =  aws.shared  }

   name             = "hub-vpc"
    cidr_block  = "10.0.0.0/16"
    az_count     =  3
}

module  "tgw"  {
   source      =  "../modules/transit-gateway"
   providers  =  { aws  =  aws.shared  }

   name  =  "core-tgw"
}

#  Example:  one workload  account  VPC
provider  "aws" {
    alias   =  "workload1"
    region =  var.region

   assume_role  {
       role_arn  =  "arn:aws:iam::${var.workload_account_ids[0]}:role/OrganizationAccountAccessRole"
   }
}

module "workload1_vpc"  {
    source     =  "../modules/vpc"
   providers  =  {  aws =  aws.workload1  }

   name             =  "workload1-vpc"
   cidr_block  =  "10.10.0.0/16"
   az_count     =  3
}

module "tgw_attachments"  {
    source     =  "../modules/transit-gateway/attachments"
   providers  =  {  aws =  aws.shared  }

   tgw_id  =  module.tgw.id
   vpcs  =  [
       {
          vpc_id         =  module.hub_vpc.id
           subnet_ids  = module.hub_vpc.tgw_subnet_ids
       },
       {
           vpc_id         =  module.workload1_vpc.id
          subnet_ids  =  module.workload1_vpc.tgw_subnet_ids
       }
   ]
}

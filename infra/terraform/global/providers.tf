
---

##  🌍 Global  org  &  SCPs  – `infra/terraform/global`

###  `providers.tf`

```hcl
terraform  {
   required_version  =  ">=  1.5.0"
   required_providers  {
       aws  =  {
          source    =  "hashicorp/aws"
          version  =  "~>  5.0"
       }
   }
}

provider  "aws"  {
   alias    =  "management"
   region  =  var.region
}

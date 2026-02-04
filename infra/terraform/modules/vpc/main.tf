variable  "name"            {  type  =  string }
variable  "cidr_block"  {  type =  string  }
variable  "az_count"     {  type  = number  }

data  "aws_availability_zones" "available"  {}

resource  "aws_vpc" "this"  {
    cidr_block                   =  var.cidr_block
    enable_dns_support     =  true
   enable_dns_hostnames  =  true

   tags  =  {
       Name =  var.name
    }
}

resource  "aws_subnet"  "public" {
    count                       =  var.az_count
   vpc_id                      =  aws_vpc.this.id
   cidr_block               = cidrsubnet(var.cidr_block,  4,  count.index)
   availability_zone  =  data.aws_availability_zones.available.names[count.index]

   tags  =  {
       Name  = "${var.name}-public-${count.index}"
    }
}

resource  "aws_subnet"  "tgw"  {
   count                       =  var.az_count
    vpc_id                     =  aws_vpc.this.id
   cidr_block               =  cidrsubnet(var.cidr_block, 4,  count.index  +  8)
   availability_zone  =  data.aws_availability_zones.available.names[count.index]

   tags  =  {
       Name =  "${var.name}-tgw-${count.index}"
    }
}

output  "id"  {
   value  =  aws_vpc.this.id
}

output  "tgw_subnet_ids"  {
   value  =  aws_subnet.tgw[*].id
}

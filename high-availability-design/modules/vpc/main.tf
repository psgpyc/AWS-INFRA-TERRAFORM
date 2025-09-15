locals {
  prefix = "eltify"
}

resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = {
      Name = "vpc-${local.prefix}"
    }
  
}

/*

1. Create 3 public subnets
2. Create 3 private subnets : for ec2
3. Create 3 private subnets: for RDS  
    
*/


resource "aws_subnet" "this" {

  vpc_id = aws_vpc.this.id

  for_each = {
    for subnet in var.subnets_config:
        "${subnet.is_public ? "public": "private" }-${subnet.az}-${subnet.res}" => subnet
  }

  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.is_public

  tags = {
    Name = "${local.prefix}-${ each.value.is_public ? "public": "private" }-${each.value.res}-subnet"
    Type = "${ each.value.is_public ? "public": "private" }"
    Az = "${each.value.az}"
  }
  
}


resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.this.id
  
}

resource "aws_eip" "this" {

  for_each = {
    for ps in aws_subnet.this:
      ps.availability_zone => ps if try(ps.tags["Type"], "") == "public"

  }  

  tags = {
    Name = "${local.prefix}-${each.key}"
  }
}



locals {
  catch_all_ip = "0.0.0.0/0"
}

resource "aws_vpc" "this" {
    
    cidr_block = var.cidr_block

    tags = {
      Name = "wh-vpc"
    
    }
  
}

resource "aws_subnet" "public" {

    vpc_id = aws_vpc.this.id
    
    cidr_block = var.public_subnet_cidr_block

    availability_zone = var.public_subnet_availability_zone


    tags = {
      Name = "public-subnet"
    }
  
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr_blocks)

    vpc_id = aws_vpc.this.id

    cidr_block = var.private_subnet_cidr_blocks[count.index]

    availability_zone = var.private_subnet_availability_zones[count.index]

    tags = {
      Name = "private-subnet-${count.index}"
    }
  
}

resource "aws_internet_gateway" "this" {

    vpc_id = aws_vpc.this.id

    tags = {
      Name = "wh-bastion-igw"
    }
  
}

resource "aws_eip" "this" {
  
  tags = {
    Name = "wh-nat-eip"
  }

  depends_on = [ aws_internet_gateway.this ]
  
}

resource "aws_nat_gateway" "this" {

  allocation_id = aws_eip.this.id
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "wh-nat-gateway"
  }

  depends_on = [ aws_subnet.public, aws_internet_gateway.this, aws_subnet.private ]

}


resource "aws_route_table" "wh-public-subnet-rt" {
    vpc_id = aws_vpc.this.id

    route {

        cidr_block = local.catch_all_ip
        gateway_id = aws_internet_gateway.this.id
    }

    tags = {
        Name = "wh-public-subnet-rt"
    }
  
}

resource "aws_route_table_association" "wh-public-subnet-rt-association" {

    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.wh-public-subnet-rt.id

}

resource "aws_route_table" "wh-private-subnet-rt" {
  vpc_id = aws_vpc.this.id


  route {
    cidr_block = local.catch_all_ip
    gateway_id = aws_nat_gateway.this.id
  }

  tags = {
        Name = "wh-private-subnet-rt"
    }
  
}

resource "aws_route_table_association" "wh-private-subnet-rt-association" {

  count = length(aws_subnet.private)

  subnet_id = aws_subnet.private[count.index].id

  route_table_id = aws_route_table.wh-private-subnet-rt.id
}
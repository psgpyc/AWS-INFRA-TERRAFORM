resource "aws_vpc" "this" {
    
    cidr_block = var.vpc_cidr_range
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "sikkavpc"
    }
  
}

resource "aws_subnet" "this" {
  for_each = {
    for subnet in var.subnets : subnet.name => subnet
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = "sikka-${each.key}"
    Type = each.value.public ? "Public" : "Private"
  }
}


resource "aws_security_group" "this" {
  name = "allow-sg"
  description = "Allow SSH, HTTP and HTTPS"
  vpc_id = aws_vpc.this.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sikkavpc-sg"
  }
  
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "sikkavpc-igw"
  }
  
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "sikkavpc-public-rt"
  }
  
}


resource "aws_route_table_association" "public_route_table_association" {
  subnet_id = aws_subnet.this["public-subnet"].id
  route_table_id = aws_route_table.public_route.id
  
}
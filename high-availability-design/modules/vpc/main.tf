locals {
  # Define a common prefix used for naming AWS resources in this module
  prefix = "eltify"
  catch_all = "0.0.0.0/0"
}

# Create the main VPC with the specified CIDR block
resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = {
      # Name tag for easy identification in the AWS console
      Name = "vpc-${local.prefix}"
    }
  
}

# 
# Subnet creation:
# This block dynamically creates subnets based on the provided configuration.
# It uses a for_each map keyed by a combination of subnet type (public/private), availability zone, and resource type.
# This ensures unique keys for each subnet and allows easy referencing elsewhere.
#
# The subnet properties such as CIDR block, AZ, and whether it maps public IPs are set based on input variables.
#
# Tags are applied for clear identification, including subnet type and AZ.
#


resource "aws_subnet" "this" {

  vpc_id = aws_vpc.this.id

  for_each = {
    for subnet in var.subnets_config:
        # Compose a unique key for each subnet using its type, AZ, and resource designation
        "${subnet.is_public ? "public": "private" }-${subnet.az}-${subnet.res}" => subnet
  }

  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.is_public

  tags = {
    # Name includes prefix, subnet type, resource type, and 'subnet' suffix for clarity
    Name = "${local.prefix}-${ each.value.is_public ? "public": "private" }-${each.value.res}-subnet"
    Type = "${ each.value.is_public ? "public": "private" }"
    Az = "${each.value.az}"
  }
  
}


# Create an Internet Gateway attached to the VPC to enable internet access for public subnets
resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.this.id
  
}

# 
# Allocate Elastic IP addresses for NAT Gateways.
# The for_each iterates over public subnets only, keyed by their availability zone.
# This approach ensures one EIP per AZ, supporting high availability and fault tolerance.
#
resource "aws_eip" "this" {

  for_each = {
    for ps in aws_subnet.this:
      # Filter only public subnets by checking the Type tag
      ps.availability_zone => ps if try(ps.tags["Type"], "") == "public"

  }  

  tags = {
    # Tag the EIP with the prefix and AZ for easy identification
    Name = "${local.prefix}-${each.key}"
  }
}

# 
# Create NAT Gateways in each public subnet to provide internet access for private subnets.
# The for_each uses the same keys as aws_eip.this to ensure NAT Gateways are created per AZ.
# Allocation IDs from the corresponding EIPs are used here.
#
# The dependency on the Internet Gateway and EIPs ensures proper resource creation order.
#
resource "aws_nat_gateway" "this" {

  for_each = {
    for ps in aws_subnet.this:
      # Filter only public subnets for NAT Gateway placement
      ps.availability_zone => ps if try(ps.tags["Type"], "") == "public"

  }  

  allocation_id = aws_eip.this[each.key].id
  subnet_id = each.value.id


  tags = {
    # Name tag includes AZ for easy identification
    Name = "NAT-at-${each.key}"
  }

  depends_on = [ aws_internet_gateway.this, aws_eip.this ]

}

# 
# Create a route table for public subnets.
# This route table directs all outbound traffic (0.0.0.0/0) to the Internet Gateway,
# enabling internet access for resources in public subnets.
#
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = local.catch_all
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "public-subnet-rt"
  }  
}

# 
# Associate public subnets with the public route table.
# This ensures that traffic from public subnets follows the routes defined in the public route table.
#
resource "aws_route_table_association" "public-rt" {

  for_each = {
    for ps in aws_subnet.this:
      ps.availability_zone => ps.id if try(ps.tags["Type"], "") == "public"
  }

  subnet_id = each.value
  route_table_id = aws_route_table.public.id

  
}

# 
# Create private route tables, one per availability zone.
# Each private route table routes all outbound traffic to the NAT Gateway in the corresponding AZ,
# allowing private subnets to access the internet securely via NAT.
#
resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id

  for_each = aws_nat_gateway.this

  route {
    cidr_block = local.catch_all
    gateway_id = each.value.id
  }

  tags = {
    Name = "private-rt-${each.key}"
  }
  
}

# 
# Associate private subnets with their respective private route tables.
# The association is done by matching subnets to route tables based on availability zone,
# ensuring private subnet traffic is routed through the correct NAT Gateway.
#
resource "aws_route_table_association" "private-rt" {

  for_each = {
    for i , ps in aws_subnet.this:
      "${ps.availability_zone}-${i}" => ps if try(ps.tags["Type"], "") == "private"
  }

  subnet_id = each.value.id

  route_table_id = aws_route_table.private[each.value.availability_zone].id
 
}

# Create a security group with the specified name, description, VPC, and tags
resource "aws_security_group" "this" {

    name = var.sec_group_name

    description = var.sec_group_description

    vpc_id = var.vpc_id

    tags = var.tags
  
}

# Define ingress rules for the security group based on the provided ingress_rule variable
resource "aws_vpc_security_group_ingress_rule" "this" {

    security_group_id = aws_security_group.this.id

    # Iterate over each ingress rule to create corresponding ingress permissions
    for_each = var.ingress_rule

    description = try(each.value.description, null)
    cidr_ipv4   = each.value.cidr_ipv4
    cidr_ipv6   = try(each.value.cidr_ipv6, null)
    from_port   = each.value.from_port
    ip_protocol = each.value.protocol
    to_port     = each.value.to_port
  
}

# Define egress rules for the security group based on the provided egress_rule variable
resource "aws_vpc_security_group_egress_rule" "this" {

    security_group_id = aws_security_group.this.id

    # Iterate over each egress rule to create corresponding egress permissions
    for_each = var.egress_rule

    description = try(each.value.description, null)
    cidr_ipv4   = each.value.cidr_ipv4
    cidr_ipv6   = try(each.value.cidr_ipv6, null)
    from_port   = each.value.from_port
    ip_protocol = each.value.protocol
    to_port     = each.value.to_port


  
}

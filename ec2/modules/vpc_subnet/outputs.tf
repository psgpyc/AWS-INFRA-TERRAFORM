output "vpc_id" {
    value = aws_vpc.this.id
}

output "subnets_ids" {
    value = {
        for name, subnet in aws_subnet.this:
            name => subnet.id
    }
  
}


output "security_group_name" {
    value = aws_security_group.this.name
}

output "security_group_id" {
    value = aws_security_group.this.id
  
}
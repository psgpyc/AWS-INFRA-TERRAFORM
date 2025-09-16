output "public_subnets" {

    description = "Object mapping to public subnet "
    value = {
        for index, subnet in aws_subnet.this:
            index => subnet if try(subnet.tags["Type"]) == "public"
    }
  
}


output "private_subnets" {

    description = "Object mapping to private subnet"

    value = {
        for index, subnet in aws_subnet.this:
            index => subnet if try(subnet.tags["Type"]) == "private"
    }
  
}


output "vpc_id" {

    value = aws_vpc.this.id
  
}

output "vpc_arn" {

    value = aws_vpc.this.arn
  
}


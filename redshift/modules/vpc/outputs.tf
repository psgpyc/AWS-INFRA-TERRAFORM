output "vpc_id" {
   value = aws_vpc.this.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id]
}


output "public_subnet_id" {
  description = "THe id of the public subnet"
  value = aws_subnet.public.id
  
}
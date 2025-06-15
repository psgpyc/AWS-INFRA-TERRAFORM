output "bastion_sg_id" {
    value = aws_security_group.bastion_sg.id
  
}

output "redshift_sg_id" {
    value = aws_security_group.redshift_sg.id
  
}
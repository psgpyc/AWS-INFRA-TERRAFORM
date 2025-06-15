resource "aws_instance" "this" {

    ami = var.ami_id

    instance_type = var.instance_type

    subnet_id = var.bastion_public_subnet_id

    associate_public_ip_address = var.associate_public_ip_address

    vpc_security_group_ids = var.vpc_security_group_ids

    key_name = var.key_pair_name

    user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt upgrade -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

    tags = {
        Name = "redshift-bastion-ec2"
    }
  
}
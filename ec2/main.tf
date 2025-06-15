module "vpc_subnet_igw" {

    source = "./modules/vpc_subnet"

    vpc_cidr_range = var.vpc_cidr_range

    subnets = var.subnets
}

resource "aws_instance" "this" {

    ami = var.ami_id

    instance_type = var.instance_type

    subnet_id = module.vpc_subnet_igw.subnets_ids["public-subnet"]

    associate_public_ip_address = var.associate_public_ip_address

    vpc_security_group_ids = [module.vpc_subnet_igw.security_group_id]

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
        Name = "sikka-ec2"
    }
  
}
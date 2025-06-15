module "vpc_subnets_igw_nat" {

    source = "./modules/vpc"

    cidr_block = var.cidr_block

    public_subnet_cidr_block = var.public_subnet_cidr_block

    public_subnet_availability_zone = var.public_subnet_availability_zone

    private_subnet_cidr_blocks = var.private_subnet_cidr_blocks

    private_subnet_availability_zones = var.private_subnet_availability_zones

  
}


module "cluster_bastion_sg" {

    source = "./modules/sg"

    vpc_id = module.vpc_subnets_igw_nat.vpc_id
  
}


module "i_am_roles" {

    source = "./modules/iam"

    wh_redshift_assume_role_policy = file("./policies/redshift_assume_role_policy.json")
    
    wh_redshift_access_policy = file("./policies/redshift_access_policy.json")

}

module "bastion_ec2" {

    source = "./modules/bastion-ec2"

    ami_id = var.ami_id

    instance_type = var.instance_type

    bastion_public_subnet_id = module.vpc_subnets_igw_nat.public_subnet_id

    vpc_security_group_ids = [module.cluster_bastion_sg.bastion_sg_id] 

    key_pair_name = var.key_pair_name

    associate_public_ip_address = true
  
}




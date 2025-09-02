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



module "redshift_cluster" {

  source = "./modules/redshift"

  private_subnets_ids = module.vpc_subnets_igw_nat.private_subnet_ids

  vpc_security_group_ids = [module.cluster_bastion_sg.redshift_sg_id]

  cluster_iam_roles = [module.i_am_roles.iam_role_arn]


  cluster_identifier = var.cluster_identifier
  node_type          = var.node_type
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password # not using secrets manager for now
  cluster_type       = var.cluster_type
  number_of_nodes    = var.number_of_nodes

}



module "log_cluster_to_s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name

  bucket_access_policy = templatefile(
    "./policies/allow_redshift_s3_bucket_policy.json.tpl",
    {
      cluster_iam_role_arn = module.i_am_roles.iam_role_arn,
      bucket_arn           = "arn:aws:s3:::${var.bucket_name}"
    }
  )

}


resource "aws_redshift_logging" "this" {
  cluster_identifier   = module.redshift_cluster.cluster_id
  log_destination_type = "s3"
  bucket_name          = module.log_cluster_to_s3.bucket_name
  s3_key_prefix        = "logs/"

  depends_on = [module.redshift_cluster]

}
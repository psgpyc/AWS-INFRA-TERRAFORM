resource "aws_redshift_subnet_group" "this" {
    name = "wh-redhsift-subnet-group"
    subnet_ids = var.private_subnets_ids
     
}

resource "aws_redshift_cluster" "main" {

    cluster_identifier = var.cluster_identifier
    node_type          = var.node_type
    database_name      = var.database_name
    master_username    = var.master_username
    master_password    = var.master_password # not using secrets manager for now
    cluster_type       = var.cluster_type
    number_of_nodes    = var.number_of_nodes

    enhanced_vpc_routing = true
    
    encrypted = true
    vpc_security_group_ids = var.vpc_security_group_ids
    iam_roles = var.cluster_iam_roles

    publicly_accessible = false

    skip_final_snapshot = true

    multi_az = true

    cluster_subnet_group_name = aws_redshift_subnet_group.this.name

    

   
  
}
variable "private_subnets_ids" {
    type = list(string)
    description = "List of private subnet ids"
  
}

variable "vpc_security_group_ids" {
    type = list(string)
    description = "A list of Virtual Private Cloud (VPC) security groups to be associated with the cluster."

  
}

variable "cluster_iam_roles" {
    type = list(string)
    description = "A list of IAM Role ARNs to associate with the cluster. A Maximum of 10 can be associated to the cluster at any time."
  
}




variable "cluster_identifier" {
    type = string
    description = "Name of your redshift cluster"
  
}



variable "node_type" {
    type = string
    description = "The node type to be provisioned for the cluster."
}


variable "database_name" {
    type = string
    description = "The name of the first database to be created when the cluster is created"
}


variable "master_username" {
    type = string
    description = "Password for the master DB user"
}

variable "master_password" {
    type = string
    description = "Password for the master DB user."
  
}

variable "cluster_type" {
    type = string
    default = "multi-node"
    description = "The cluster type to use."
  
}

variable "number_of_nodes" {
    type = string
    description = "The number of compute nodes in the cluster."
  
}
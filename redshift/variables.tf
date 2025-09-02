variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for VPC"

}

variable "public_subnet_cidr_block" {
  type        = string
  default     = "10.0.0.0/24"
  description = "Public Subnet CIDR block"

}

variable "public_subnet_availability_zone" {
  type        = string
  default     = "eu-west-2a"
  description = "Availability Zone for the Public Subnet"

}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "List of CIDR Blocks for Private Subnet"

}

variable "private_subnet_availability_zones" {
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  description = "List of Availability Zones for Private Subnet"
}


# bastion ec2


variable "ami_id" {
  type        = string
  description = "Your ec2 ami id"

}

variable "instance_type" {
  type        = string
  description = "your ec2 instance type"

}


variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "Associate public ip address for this instance"

}


variable "key_pair_name" {
  type        = string
  description = "Key name for your instance"

}


# redshift cluster


variable "cluster_identifier" {
  type        = string
  description = "Name of your redshift cluster"

}



variable "node_type" {
  type        = string
  description = "The node type to be provisioned for the cluster."
}

variable "number_of_nodes" {
  type        = string
  description = "The number of compute nodes in the cluster."

}


variable "database_name" {
  type        = string
  description = "The name of the first database to be created when the cluster is created"
}


variable "master_username" {
  type        = string
  description = "Password for the master DB user"
}

variable "master_password" {
  type        = string
  description = "Password for the master DB user."

}

variable "cluster_type" {
  type        = string
  default     = "multi-node"
  description = "The cluster type to use."

}

# s3

variable "bucket_name" {
  type        = string
  description = "The name of the bucket"

}
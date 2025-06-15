
variable "ami_id" {
    type = string
    description = "Your ec2 ami id"
  
}

variable "instance_type" {
    type = string
    description = "your ec2 instance type"
  
}

variable "associate_public_ip_address" {
    type = bool
    default = false
    description = "Associate public ip address for this instance"
  
}

variable "key_pair_name" {
    type = string
    description = "Key name for your instance"
  
}

variable "bastion_public_subnet_id" {
    type = string
    description = "Id Subnet where bastion ec2 is to be placed"
  
}

variable "vpc_security_group_ids" {
    type = list(string)
    description = ""
  
}
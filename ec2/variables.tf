variable "aws_region" {
    type = string
    default = "eu-west-2"
    description = "The name of your aws region"
  
}

variable "vpc_cidr_range" {
    type = string
    description = "The CIDR range for vpc"
  
}

variable "subnets" {
    type = list(object({
        name = string
        cidr_block = string
        az = string
        public = bool
    }))
    description = "List of subnets to create"
  
}

# instance

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
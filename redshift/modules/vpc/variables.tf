variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "CIDR block for VPC"
  
}

variable "public_subnet_cidr_block" {
    type = string
    default = "10.0.0.0/24"
    description = "Public Subnet CIDR block"
  
}

variable "public_subnet_availability_zone" {
    type = string
    default = "eu-west-2a"
    description = "Availability Zone for the Public Subnet"
  
}

variable "private_subnet_cidr_blocks" {
    type = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
    description = "List of CIDR Blocks for Private Subnet"
  
}

variable "private_subnet_availability_zones" {
    type = list(string)
    default = ["eu-west-2a", "eu-west-2b", "eu-west-2c" ]
    description = "List of Availability Zones for Private Subnet"
}

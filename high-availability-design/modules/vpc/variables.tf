variable "vpc_cidr" {

    type = string
    default = "10.0.0.0/16"
  
}

variable "subnets_config" {
    type = list(map(string))

    default = [ 
        {
            "cidr_block" = "10.0.1.0/24"
            "az" = "eu-west-2a"
            "is_public" = true
            "res" = "alb"
        },
        {
            "cidr_block" = "10.0.2.0/24"
            "az" = "eu-west-2b"
            "is_public" = true
             "res" = "alb"
        },
        {
            "cidr_block" = "10.0.3.0/24"
            "az" = "eu-west-2c"
            "is_public" = true
             "res" = "alb"
        },
        {
            "cidr_block" = "10.0.11.0/24"
            "az" = "eu-west-2a"
            "is_public" = false
             "res" = "ec2"
        },
        {
            "cidr_block" = "10.0.12.0/24"
            "az" = "eu-west-2b"
            "is_public" = false
            "res" = "ec2"

        },
        {
            "cidr_block" = "10.0.13.0/24"
            "az" = "eu-west-2c"
            "is_public" = false
            "res" = "ec2"
        },
        {
            "cidr_block" = "10.0.21.0/24"
            "az" = "eu-west-2a"
            "is_public" = false
            "res" = "rds"
        },
        {
            "cidr_block" = "10.0.22.0/24"
            "az" = "eu-west-2b"
            "is_public" = false
            "res" = "rds"
        },
        {
            "cidr_block" = "10.0.23.0/24"
            "az" = "eu-west-2c"
            "is_public" = false
            "res" = "rds"
        },
     ]
}
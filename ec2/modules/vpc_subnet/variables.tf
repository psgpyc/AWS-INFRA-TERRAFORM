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
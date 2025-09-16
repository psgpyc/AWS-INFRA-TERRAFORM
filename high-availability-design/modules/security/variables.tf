variable "sec_group_name" {
    
    type = string
  
}


variable "sec_group_description" {

    type = string
}

variable "vpc_id" {

    type = string
  
}

variable "tags" {

    type = map(string)
    default = {}
  
}


variable "ingress_rule" {

    type = map(object({
      description = optional(string)
      cidr_ipv4 = string
      cidr_ipv6 = optional(string)
      from_port = number
      to_port = number
      ip_protocol = string

    }))

    default = {}

}
  
variable "egress_rule" {

    type = map(object({
        
      description = optional(string)
      cidr_ipv4 = string
      cidr_ipv6 = optional(string)
      from_port = number
      to_port = number
      ip_protocol = string

    }))

    default = {}

}
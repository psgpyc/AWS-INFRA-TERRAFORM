variable "iam_role_name" {
    
    type = string
    description = "Name of the iam role"
  
}

variable "assume_role_policy" {

    type = string
    description = "The trust policy for IAM role"

}

variable "iam_policy" {

    type = string
    description = "The IAM policy to be attached to the IAM role"
  
}
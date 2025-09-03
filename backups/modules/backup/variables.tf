variable "backup_vault_name" {

    type = string
  
}

variable "kms_key_arn" {

    type = string
  
}


variable "backup_plan_name" {

    type = string

}

variable "backup_rule_name" {

    type = string
  
}

variable "backup_iam_role_arn" {

    type = string
  
}


variable "backup_selection_name" {

    type = string
  
}


variable "resource_arns_to_backup" {

    type = list(string)
  
}
data "aws_caller_identity" "current" {
}

locals {
    root_account = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}


resource "aws_iam_service_linked_role" "backup" {

    aws_service_name = "backup.amazonaws.com"

  
}

data "aws_iam_role" "aws_backup_service_role" {
    
    name = "AWSServiceRoleForBackup"
    depends_on = [ aws_iam_service_linked_role.backup ]
    
}


resource "aws_kms_key" "this" {

    enable_key_rotation = true
    deletion_window_in_days = 7

}

resource "aws_kms_key_policy" "this" {

    key_id = aws_kms_key.this.id

    policy = templatefile("./policies/key_access_policy.json.tpl", 
        {
            backup_iam_role_arn = data.aws_iam_role.aws_backup_service_role.arn,
            root_account_arn = local.root_account
        }
    ) 
}

resource "aws_kms_alias" "this" {

    name = "alias/cmk-backup"
    target_key_id = aws_kms_key.this.id
  
}


module "s3_bucket_module" {

    source = "./modules/s3"


    bucket_name = var.bucket_name

}


module "backup_module" {

    source = "./modules/backup"
    
    providers = {
      "aws": aws.london
    }

    backup_vault_name = var.backup_vault_name

    kms_key_arn = aws_kms_key.this.arn

    backup_plan_name = "${var.backup_vault_name}-plan"

    backup_rule_name = "${var.backup_vault_name}-rule"

    backup_iam_role_arn = data.aws_iam_role.aws_backup_service_role.arn

    backup_selection_name = var.backup_selection_name

    resource_arns_to_backup = [ module.s3_bucket_module.bucket_arn]

  
}
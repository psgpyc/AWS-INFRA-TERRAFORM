
resource "aws_backup_vault" "this" {

    name = var.backup_vault_name
    
    kms_key_arn = var.kms_key_arn
  
}

resource "aws_backup_plan" "this" {

    name = var.backup_plan_name

    rule {
      rule_name = var.backup_rule_name

      target_vault_name = aws_backup_vault.this.name

      schedule = "cron(0 0 * * ? *)"  #daily at 00:00 UTC

      start_window = 60  #60 minutes grace period to start

      completion_window = 180 # must finish the backup within 3 hours, or marked as failed


      lifecycle {

        cold_storage_after = 30
        delete_after = 365

      }


    }
  
}


resource "aws_backup_selection" "by_resource_arn" {

    iam_role_arn = var.backup_iam_role_arn

    name = var.backup_selection_name

    plan_id = aws_backup_plan.this.id


    resources = var.resource_arns_to_backup
  
}




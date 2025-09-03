{
    "Version": "2012-10-17",
    "Statement":  [
        {
            "Sid":  "AllowRootFullAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${root_account_arn}"
            },
            "Action":  "kms:*",
            "Resource":  "*"

        },   
        {
            "Sid": "AllowSLRUsusageAccess",
            "Effect": "Allow",  
            "Principal": {
                "AWS":  "${backup_iam_role_arn}"
            },
            "Action":  [
                "kms:DescribeKey",
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey",
                "kms:GenerateDataKeyWithoutPlaintext"
            ],
            "Resource":  "*"
        }
    ]
}
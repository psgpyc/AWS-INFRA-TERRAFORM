{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "AllowRedshiftToWriteLogs",
        "Effect":  "Allow",
        "Principal": {
            "AWS": "${cluster_iam_role_arn}"
        },
        "Action": "*",
        "Resource": [
            "${bucket_arn}",
            "${bucket_arn}/*"
        ]
    }]
}
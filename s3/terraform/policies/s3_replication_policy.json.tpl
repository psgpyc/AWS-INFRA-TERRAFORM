{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": [
                "s3:ListBucket",
                "s3:GetReplicationConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectRetention",
                "s3:GetObjectLegalHold"
        ],
        "Resource": [
            "arn:aws:s3:::${source_bucket_name}",
            "arn:aws:s3:::${source_bucket_name}/*",
            "arn:aws:s3:::${destination_bucket_name}",
            "arn:aws:s3:::${destination_bucket_name}/*"

        ]

    },
    {
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags",
                "s3:ObjectOwnerOverrideToBucketOwner",
                "s3:GetBucketVersioning",
                "s3:PutBucketVersioning"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${destination_bucket_name}",
                "arn:aws:s3:::${destination_bucket_name}/*"
            ]
        }]
    
}
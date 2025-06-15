resource "aws_iam_role" "this" {
    name = "wh-redhsift-assume-role"
    assume_role_policy = var.wh_redshift_assume_role_policy 
}

resource "aws_iam_policy" "this" {
    name = "wh-redhsift-access-policy"
    policy = var.wh_redshift_access_policy
}


resource "aws_iam_role_policy_attachment" "this" {
    role = aws_iam_role.this.name
    policy_arn = aws_iam_policy.this.arn
}
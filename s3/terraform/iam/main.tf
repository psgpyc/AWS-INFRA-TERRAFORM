resource "aws_iam_role" "this" {
  name = var.iam_role_name
  assume_role_policy = var.iam_role_policy
}

resource "aws_iam_policy" "this" {
  name = var.iam_policy_name
  policy = var.iam_policy
  
}

resource "aws_iam_role_policy_attachment" "this" {
    role = aws_iam_role.this.name
    policy_arn = aws_iam_policy.this.arn
  
}
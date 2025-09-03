resource "aws_iam_role" "this" {

    name = var.iam_role_name

    assume_role_policy = var.assume_role_policy
  
}

resource "aws_iam_policy" "this" {

    name = "${aws_iam_role.this}-policy"
    
    policy = var.iam_policy
  
}

resource "aws_iam_role_policy_attachment" "this" {

    role = aws_iam_policy.this.name
    policy_arn = aws_iam_policy.this.arn

    depends_on = [ aws_iam_role.this, aws_iam_policy.this ]

  
}
## Creating I am role for EC2 intance to access s3
resource "aws_iam_role" "web_iam_role" {
    name = "s3-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Create instance profile 
resource "aws_iam_instance_profile" "instance_profile" {
    name = "web_instance_profile"
    role = aws_iam_role.web_iam_role.id
}

## Creating role policy for s3 access
resource "aws_iam_role_policy" "s3_iam_role_policy" {
  name = "s3_iam_role_policy"
  role = aws_iam_role.web_iam_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": ["arn:aws:s3:::dinesh12345test/*"]
    }
  ]
}
EOF
}


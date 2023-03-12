
# Based on example from here 
# https://skundunotes.com/2021/11/16/attach-iam-role-to-aws-ec2-instance-using-terraform/
# 
resource "aws_iam_policy" "ec2_policy" {
  name        = "S3RoleForEC2_Policy"
  path        = "/"
  description = "Policy to provide permission to EC2"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "s3:*",
          "s3-object-lambda:*"
        ],
        "Resource": ["*"]
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "S3RoleForEC2_Role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


#Attach role to policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name       = "S3RoleForEC2_Attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
}

#Attach role to an instance profile
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "S3RoleForEC2_Profile"
  role = aws_iam_role.ec2_role.name
}


# resource "aws_iam_role" "s3_role" {
#   name = "S3RoleForEC2"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })

#   inline_policy {

#     policy  = jsonencode({
#         "Version": "2012-10-17",
#         "Statement": [
#             {
#                 "Effect": "Allow",
#                 "Action": [
#                     "s3:*",
#                     "s3-object-lambda:*"
#                 ],
#                 "Resource": "*"
#             }
#         ]
#     })
#   }

#   tags = {
#     name = "S3RoleForEC2"
#   }
# }
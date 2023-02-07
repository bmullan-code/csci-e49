# data "aws_vpc" "lab1_vpc" {
#   filter {
#     name = "tag:Name"
#     values = ["lab1-vpc"]
#   }
# }

# data "aws_subnet" "lab1_subnet" {
#   filter {
#     name = "tag:Name"
#     values = ["lab1-us-east-1b"]
#   }
# }

# data "aws_security_group" "lab1_sg" {
#   filter {
#     name = "group-name"
#     values = ["lab1-securitygroup-web-linux"]
#   }
# }

# data "aws_kms_key" "lab1_kms" {
#   key_id = "alias/lab1-cscie49-key"
# }

# data "aws_key_pair" "lab1_key_pair" {
#   key_name = "lab1-csci-e49-key-pair"
# }

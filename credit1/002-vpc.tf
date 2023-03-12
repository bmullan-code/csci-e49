
data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name =  "${var.prefix}-eclab1vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}


# resource "aws_vpc" "main" {
#    cidr_block       = "${var.vpc_cidr}"

#    tags = {
#     Name = "${var.prefix}-eclab1vpc"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "${var.prefix}-igw"
#   }
# }

# resource "aws_subnet" "subnet1" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "${var.subnet1_cidr}"  
#   availability_zone = "us-east-1a"
#   map_public_ip_on_launch = "true"
#    tags = {
#     Name = "${var.prefix}-us-east-1a"
#   }
# }

# resource "aws_subnet" "subnet2" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "${var.subnet2_cidr}"  
#   availability_zone = "us-east-1b"
#   map_public_ip_on_launch = "true"
#    tags = {
#     Name = "${var.prefix}-us-east-1b"
#   }
# }

# resource "aws_route_table" "rt1" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = {
#     Name = "${var.prefix}-route-table"
#   }
# }

# resource "aws_route_table_association" "subnet1" {
#   subnet_id      = aws_subnet.subnet1.id
#   route_table_id = aws_route_table.rt1.id
# }

# resource "aws_route_table_association" "subnet2" {
#   subnet_id      = aws_subnet.subnet2.id
#   route_table_id = aws_route_table.rt1.id
# }

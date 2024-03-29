### 
### Create the VPC, gateway, subnets and routes
###
resource "aws_vpc" "main" {
   cidr_block           = "${var.vpc_cidr}"
   enable_dns_support   = true
   enable_dns_hostnames = true

   tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.subnet1_cidr}"  
  availability_zone = "us-east-1a"
   tags = {
    Name = "${var.prefix}-public-us-east-1a"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.subnet2_cidr}"
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.prefix}-private-us-east-1a"
  }
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-route-table"
  }
}

resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt1.id
}
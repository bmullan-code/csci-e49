###
### Create the RDS instance
###
resource "aws_db_subnet_group" "lab3-subnet-group" {
  name       = "${var.prefix}-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]

  tags = {
    Name = "${var.prefix}-subnet-group"
  }
}

resource "aws_db_instance" "lab3db" {
  multi_az               = false
  identifier             = "${var.prefix}-database"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7.41"
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.lab3-subnet-group.name
  vpc_security_group_ids = [aws_security_group.securitygroup_web_linux.id]
#   parameter_group_name   = aws_db_parameter_group.lab3db.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}

resource "local_file" "dbinfo" {
  filename = "dbinfo.inc"
  content = templatefile("dbinfo.tftpl", { db_server = aws_db_instance.lab3db.endpoint })
}

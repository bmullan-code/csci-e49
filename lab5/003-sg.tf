###
### Create the security group with firewall rules
###
resource "aws_security_group" "securitygroup_web_linux" {
  name        = "${var.prefix}-securitygroup-web-linux"
  description = "securitygroup_web_linux"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh"
    to_port          = 22
    from_port        = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    description      = "http"
    to_port          = 80
    from_port        = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    description      = "https"
    to_port          = 443
    from_port        = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    description      = "custom vpn"
    to_port          = 943
    from_port        = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    description      = "custom udp"
    to_port          = 1194
    from_port        = 0
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

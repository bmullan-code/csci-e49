data "aws_ami" "amazon-linux-2" {
 most_recent = true
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_instance" "webserver1" {
  ami = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.micro"
  key_name = aws_key_pair.my-key-pair.key_name
  subnet_id = aws_subnet.subnet1.id
  associate_public_ip_address = true
  security_groups = [ aws_security_group.securitygroup_web_linux.id ]
  
  root_block_device {
    volume_size = 16
    encrypted   = true
    kms_key_id  = aws_kms_key.a.key_id
  }

  tags = {
    Name = "barrymullan_lab1_webserver1"
  }

  user_data = <<EOF
#!/bin/bash 
yum update -y 
yum install -y httpd php php-mysqlnd openssl mod_ssl 
service httpd start 
chkconfig httpd on 
cd /var/www/html 
wget https://cscie49-rameshnagappan.s3.amazonaws.com/ha-website1.zip 
unzip ha-website1.zip 
chmod +rx website 
EOF
}

resource "aws_instance" "webserver2" {
  ami = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.micro"
  key_name = aws_key_pair.my-key-pair.key_name
  subnet_id = aws_subnet.subnet2.id
  associate_public_ip_address = true
  security_groups = [ aws_security_group.securitygroup_web_linux.id ]
  
  root_block_device {
    volume_size = 16
    encrypted   = true
    kms_key_id  = aws_kms_key.a.key_id
  }

  tags = {
    Name = "barrymullan_lab1_webserver2"
  }

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd php php-mysqlnd openssl mod_ssl
service httpd start
chkconfig httpd on
cd /var/www/html
wget https://cscie49-rameshnagappan.s3.amazonaws.com/ha-website2.zip
unzip ha-website2.zip
chmod +rx website
EOF
}
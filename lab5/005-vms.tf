###
### Create the web server instance
###
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

  # depends on rds instance being created first
  depends_on = [
    local_file.dbinfo
  ]

  ami = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.micro"
  key_name = aws_key_pair.my-key-pair.key_name
  subnet_id = aws_subnet.subnet1.id
  associate_public_ip_address = true
  security_groups = [ aws_security_group.securitygroup_web_linux.id ]

  connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(local_file.ssh_key.filename) # "${file("${var.prefix}-${aws_key_pair.my-key-pair.key_name}.pem")}"
      host        = "${self.public_ip}"
  }

  provisioner "file" {
        source      = "dbinfo.inc"
        destination = "/home/ec2-user/dbinfo.inc"
  }

  provisioner "file" {
        source      = "lab3.php"
        destination = "/home/ec2-user/lab3.php"
  }
  
  provisioner "file" {
        source      = "startup.sh"
        destination = "/home/ec2-user/startup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/startup.sh",
      "/home/ec2-user/startup.sh"
    ]
  }


  root_block_device {
    volume_size = 16
  }

  tags = {
    Name = "${var.prefix}-barrymullan-lab1-webserver1"
  }

}

###
### Create the web server instance
###
data "aws_ami" "openvpn" {
 most_recent = true
 filter {
   name   = "image-id"
   values = ["ami-0f95ee6f985388d58"]
 }
}

resource "aws_instance" "webserver1" {

  # depends on rds instance being created first
  depends_on = [
    local_file.dbinfo
  ]

  ami = "${data.aws_ami.openvpn.id}"
  instance_type = "t2.small"
  key_name = aws_key_pair.my-key-pair.key_name
  subnet_id = aws_subnet.subnet1.id
  associate_public_ip_address = false
  security_groups = [ aws_security_group.securitygroup_web_linux.id ]

  # connection {
  #     type        = "ssh"
  #     user        = "ec2-user"
  #     private_key = file(local_file.ssh_key.filename) # "${file("${var.prefix}-${aws_key_pair.my-key-pair.key_name}.pem")}"
  #     host        = "${self.public_ip}"
  # }

  # provisioner "file" {
  #       source      = "dbinfo.inc"
  #       destination = "/home/ec2-user/dbinfo.inc"
  # }

  # provisioner "file" {
  #       source      = "lab3.php"
  #       destination = "/home/ec2-user/lab3.php"
  # }
  
  # provisioner "file" {
  #       source      = "startup.sh"
  #       destination = "/home/ec2-user/startup.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /home/ec2-user/startup.sh",
  #     "/home/ec2-user/startup.sh"
  #   ]
  # }


  root_block_device {
    volume_size = 16
  }

  tags = {
    Name = "${var.prefix}-barrymullan-lab1-webserver1"
  }

}

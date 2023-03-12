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

  depends_on = [
    aws_s3_bucket.bucket
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
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
        source      = "barrymullan.html"
        destination = "/home/ec2-user/barrymullan.html"
  }

  # provisioner "file" {
  #       source      = "lab3.php"
  #       destination = "/home/ec2-user/lab3.php"
  # }
  
  # provisioner "file" {
  #       source      = "startup.sh"
  #       destination = "/home/ec2-user/startup.sh"
  # }

  provisioner "remote-exec" {
    inline = [
      "aws s3 cp /home/ec2-user/barrymullan.html s3://barrymullan2023ec2"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "aws s3 presign s3://barrymullan2023ec2/barrymullan.html --expires-in 5184000"
    ]
  }

  root_block_device {
    volume_size = 16
    encrypted   = true
    kms_key_id  = aws_kms_key.a.key_id
  }

  tags = {
    Name = "${var.prefix}_barrymullan_lab4"
  }

  user_data = <<EOF


EOF
}

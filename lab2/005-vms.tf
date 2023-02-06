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

resource "aws_instance" "lab2_instance" {
  ami = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.micro"
  key_name = data.aws_key_pair.lab1_key_pair.key_name
  subnet_id = data.aws_subnet.lab1_subnet.id
  associate_public_ip_address = true
  security_groups = [ data.aws_security_group.lab1_sg.id ]
  
  root_block_device {
    volume_size = 16
    encrypted   = true
    kms_key_id  = data.aws_kms_key.lab1_kms.key_id
  }

  tags = {
    Name = "${var.prefix}-instance"
  }

  user_data = <<EOF
#!/bin/bash
public_ip=$(curl -sL http://169.254.169.254/latest/meta-data/public-ipv4)
private_ip=$(curl -sL http://169.254.169.254/latest/meta-data/local-ipv4)
hostname=$(curl -sL http://169.254.169.254/latest/meta-data/local-hostname)
security_group=$(curl -sL http://169.254.169.254/latest/meta-data/security-groups)
instance_id=$(curl -sL http://169.254.169.254/latest/meta-data/instance-id)
instance_type=$(curl -sL http://169.254.169.254/latest/meta-data/instance-type)
ami_id=$(curl -sL http://169.254.169.254/latest/meta-data/ami-id)
echo "<html>" > index.html
echo "<h1> My First Docker Container on EC2 - Container Host Details</h1>" >> index.html
echo "<h2> Public IP: $public_ip </h2>" >> index.html
echo "<h2> Private IP: $private_ip </h2>" >> index.html
echo "<h2> Hostname: $hostname </h2>" >> index.html
echo "<h2> Security Group: $security_group </h2>" >> index.html
echo "<h2> Instance ID: $instance_id </h2>" >> index.html
echo "<h2> Instance Type: $instance_type </h2>" >> index.html
echo "<h2> AMI ID: $ami_id </h2>" >> index.html
echo "</html>" >> index.html
wget https://cscie49-rameshnagappan.s3.amazonaws.com/Dockerfile
chmod +rx Dockerfile
cp Dockerfile /home/ec2-user
cp index.html /home/ec2-user

sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
docker info
cd /home/ec2-user
docker build -t lab2docker .
docker images --filter reference=lab2docker
docker run -t -d -p 80:80 lab2docker:latest

EOF
}

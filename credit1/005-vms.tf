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

resource "aws_instance" "kubecluster-ec2" {
  ami = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.micro"
  key_name = aws_key_pair.my-key-pair.key_name
  subnet_id = aws_subnet.subnet1.id
  associate_public_ip_address = true
  security_groups = [ aws_security_group.securitygroup_web_linux.id ]
  
  root_block_device {
    volume_size = 16
  }

  tags = {
    Name = "${var.prefix}-kubecluster-ec2"
  }

  user_data = <<EOF
#!/bin/bash 
yum update -y 
cd /home/ec2-user
aws --version
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
which aws
sudo ./aws/install --bin-dir /usr/bin --install-dir /usr/bin/aws-cli --update
aws --version

cd /home/ec2-user
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo cp ./kubectl /usr/local/bin
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export
PATH=$PATH:$HOME/bin
kubectl version --short --client

curl --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" --silent | tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin
eksctl version


EOF
}

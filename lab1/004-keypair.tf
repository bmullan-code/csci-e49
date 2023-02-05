resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my-key-pair" {
  key_name   = "csci-e49-key-pair"
  public_key = tls_private_key.example.public_key_openssh
}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my-key-pair" {
  key_name   = "${var.prefix}-csci-e49-key-pair"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${var.prefix}-${aws_key_pair.my-key-pair.key_name}.pem"
  content = tls_private_key.example.private_key_pem
}

resource "aws_s3_object" "object" {
  bucket = "${var.bucket_name}"
  key    = "/keys/${local_file.ssh_key.filename}"
  source = "${local_file.ssh_key.filename}"
}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my-key-pair" {
  key_name   = "${var.prefix}-csci-e49-key-pair"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.my-key-pair.key_name}.pem"
  content = tls_private_key.example.private_key_pem
  file_permission = "0400"
}

resource "aws_s3_object" "object" {
  bucket = "${var.bucket_name}"
  key    = "/keys/${local_file.ssh_key.filename}"
  source = "${local_file.ssh_key.filename}"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  # etag = filemd5("${local_file.ssh_key.filename}")
}


resource "tls_self_signed_cert" "cert" {
  
  private_key_pem   = "${tls_private_key.example.private_key_pem}"

  subject {
    country = "US"
    locality = "Boston"
    organization = "Harvard University"
    organizational_unit = "Extension"
    common_name  = "cscie49-mullan"
    
  }
  validity_period_hours = 48

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

}


resource "aws_iam_server_certificate" "cert" {
  name             = "${var.prefix}-${tls_self_signed_cert.cert.subject[0].common_name}"
  certificate_body = "${tls_self_signed_cert.cert.cert_pem}"
  private_key      = "${tls_private_key.example.private_key_pem}"
  
  lifecycle {
   create_before_destroy = true
  }
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa-private-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "cert" {
  # private_key_pem = file("private_key.pem")
  private_key_pem   = "${tls_private_key.rsa-private-key.private_key_pem}"

  subject {
    country = "US"
    locality = "Boston"
    organization = "Harvard University"
    organizational_unit = "Extension"
    common_name  = "cscie49-mullan"
    
  }
  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

}

#resource "local_file" "private_key" {
#  content  = "${tls_private_key.rsa-private-key.private_key_pem}"
#  filename = "privateKey.key"
#}

#resource "local_file" "cert" {
#  content  = "${tls_self_signed_cert.cert.cert_pem}"
#  filename = "certificate.crt"
#}

resource "aws_iam_server_certificate" "cert" {
  name             = tls_self_signed_cert.cert.subject[0].common_name
  certificate_body = "${tls_self_signed_cert.cert.cert_pem}"
  private_key      = "${tls_private_key.rsa-private-key.private_key_pem}"
  
  lifecycle {
    create_before_destroy = true
  }
}
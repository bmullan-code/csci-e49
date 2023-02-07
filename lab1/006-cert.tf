
# RSA key of size 4096 bits
resource "tls_private_key" "rsa-private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "cert" {
  
  private_key_pem   = "${tls_private_key.rsa-private-key.private_key_pem}"

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
  # name             = tls_self_signed_cert.cert.subject[0].common_name
  name_prefix      = "${var.prefix}-${tls_self_signed_cert.cert.subject[0].common_name}"
  certificate_body = "${tls_self_signed_cert.cert.cert_pem}"
  private_key      = "${tls_private_key.rsa-private-key.private_key_pem}"
  
  lifecycle {
    create_before_destroy = true
  }
}
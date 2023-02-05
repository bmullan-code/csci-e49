resource "aws_kms_key" "a" {
  key_usage = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  description             = "Symmetric Key for Lab 1"
  deletion_window_in_days = 10
  tags = {
    Name = "cscie49-key"
  }
}

resource "aws_kms_alias" "a" {
  name          = "alias/cscie49-key"
  target_key_id = aws_kms_key.a.key_id
}

resource "aws_s3_bucket" "bucket" {
  bucket = "barrymullan2023ec2"

  tags = {
    Name        = "barrymullan2023ec2"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}
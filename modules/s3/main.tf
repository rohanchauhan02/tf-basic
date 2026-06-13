resource "aws_s3_bucket" "my_bucket" {
  bucket = "rohan-tf-demo-bucket-2026"

  tags = {
    Name = "Rohan_S3_Bucket"
  }
}

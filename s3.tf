resource "aws_s3_bucket" "imagenes" {
  bucket = "${var.layer}-${var.stack_id}-imagenes"
  acl    = "private"

  tags = {
    Name        = "${var.layer}-${var.stack_id}-imagenes"
    Environment = var.stack_id
  }
}

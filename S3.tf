resource "aws_s3_bucket" "bucket" {
bucket = "event_bucket_name"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.bucket.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.s3lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "<_prefix_if_any_dir_in_s3>/"
    filter_suffix       = "<_suffix_of_file_put_in_s3>"
  }
}

resource "aws_lambda_function" "s3lambda" {
  filename      = "code.zip"
  function_name = "s3_event_lambda"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "lambda_function.lambda_handler"
  runtime   = "python2.7"
}

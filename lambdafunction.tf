resource "aws_lambda_function" "s3lambda" {
  filename      = "code.zip"
  function_name = "s3_event_lambda"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "lambda_function.lambda_handler"
  runtime   = "python2.7"
}

-----------------------------------------------------------------------------------------------------------------------------------------------


resource "aws_iam_role" "role" {
  name = "${var.env_prefix_name}-alb-logs-to-elk"
  path = "/"

      assume_role_policy = <<EOF
    {

  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

To make it easy you can do this in three steps,

create a role
create policy
attached policy to the role
attached role to lambda
Create role.

resource "aws_iam_role" "role" {
  name = "${var.env_prefix_name}-alb-logs-to-elk"
  path = "/"

      assume_role_policy = <<EOF
    {

  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
  
Create a policy that has specified access to s3

 #Created Policy for IAM Role
resource "aws_iam_policy" "policy" {
  name = "${var.env_prefix_name}-test-policy"
  description = "A test policy"


      policy = <<EOF
   {
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": "arn:aws:s3:::*"
    }
]

} 
    EOF
    }


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_lambda_function" "test_lambda" {
  # filename         = "crawler/dist/deploy.zip"
  s3_bucket = "${var.s3-bucket}"
  s3_key    = "${aws_s3_bucket_object.file_upload.key}"
  # source_code_hash = "${filebase64sha256("file.zip")}"
  function_name    = "quote-crawler"
  role             = "${aws_iam_role.role.arn}"
  handler          = "handler.handler"
  source_code_hash = "${data.archive_file.zipit.output_base64sha256}"
  runtime          = "${var.runtime}"
  timeout          = 180

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# check the Iam role and adjust if it doesn't work

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::bucket-name"]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["arn:aws:s3:::bucket-name/*"]
        }
    ]
}











data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda/lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


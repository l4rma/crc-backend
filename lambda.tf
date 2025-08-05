data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "src/"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "increment_view_counter" {
  function_name = "increment_and_return_counter"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "inc_and_return_counter.increment_counter"
  runtime       = "python3.12"
  timeout       = 5

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
}

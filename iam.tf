data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }

}

data "aws_iam_policy_document" "lambda_logs" {
  statement {
    sid    = "AllowCloudWatch"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "logs" {
  name        = "lambda-logs"
  description = "Allow Lambda to write logs to CloudWatch"
  policy      = data.aws_iam_policy_document.lambda_logs.json
}

data "aws_iam_policy_document" "lambda_dynamodb" {
  statement {
    sid    = "AllowDynamoDB"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      aws_dynamodb_table.crc_visitor_counter.arn
    ]
  }
}

resource "aws_iam_policy" "dynamodb" {
  name        = "lambda-dynamodb"
  description = "Allow Lambda to interact with the visitor counter table"
  policy      = data.aws_iam_policy_document.lambda_dynamodb.json
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  managed_policy_arns = [
    aws_iam_policy.logs.arn,
    aws_iam_policy.dynamodb.arn,
  ]
}


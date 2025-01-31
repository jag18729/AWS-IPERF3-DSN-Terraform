# IAM role for Lambda
resource "aws_iam_role" "lambda_terminate" {
  provider = aws.pasadena
  name     = "${var.project_name}-termination-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for termination
resource "aws_iam_role_policy" "lambda_terminate_policy" {
  provider = aws.pasadena
  name     = "${var.project_name}-termination-policy"
  role     = aws_iam_role.lambda_terminate.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Lambda function for termination
resource "aws_lambda_function" "auto_terminate" {
  provider      = aws.pasadena
  filename      = "termination_lambda.zip"
  function_name = "${var.project_name}-auto-termination"
  role          = aws_iam_role.lambda_terminate.arn
  handler       = "index.handler"
  runtime       = "python3.9"

  environment {
    variables = {
      PROJECT_NAME = var.project_name
    }
  }
}

# CloudWatch Event rule to trigger Lambda
resource "aws_cloudwatch_event_rule" "check_termination" {
  provider            = aws.pasadena
  name                = "${var.project_name}-termination-check"
  description         = "Check for instances to terminate daily"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  provider  = aws.pasadena
  rule      = aws_cloudwatch_event_rule.check_termination.name
  target_id = "CheckTermination"
  arn       = aws_lambda_function.auto_terminate.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  provider      = aws.pasadena
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_terminate.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.check_termination.arn
}
resource "aws_lambda_function" "challenge" {
  function_name = var.lambda_function_name
  filename      = "deployment-package.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  role = aws_iam_role.challenge.arn

  environment {
    variables = var.environment
  }
}

resource "aws_lambda_alias" "this" {
  name             = "challenge"
  description      = "Challenge DevSecOps/SRE" 
  function_name    = aws_lambda_function.challenge.function_name
  function_version = "$LATEST"
}

resource "aws_iam_role" "challenge" {
  name = "${var.lambda_function_name}_execution_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": ["sts:AssumeRole"],
            "Effect": "allow",
            "Principal": {"Service": ["lambda.amazonaws.com"]}
        }
    ]
}
EOF

}

output "lambda_function_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway"
  value       = aws_lambda_function.challenge.invoke_arn
}
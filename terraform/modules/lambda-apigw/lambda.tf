data "archive_file" "ocr_lambda_zip" {
  type = "zip"
  source_dir = "${path.module}/../../../lambda-functions/ocr-lambda"
  output_path = "${path.module}/../../../lambda-functions/ocr-lambda.zip"
}

resource "aws_lambda_function" "ocr_lambda" {
  function_name = "ocr-lambda"
  handler = "ocr-lambda.handler"
  runtime = var.python_runtime
  role = aws_iam_role.ocr_lambda_role.arn
  filename = data.archive_file.ocr_lambda_zip.output_path
}

resource "aws_iam_role" "ocr_lambda_role" {
  name = "ocr-lambda-role"
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

resource "aws_lambda_permission" "api_gw_invoke" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ocr_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.apigw_rest_api.execution_arn}/*/*"
}

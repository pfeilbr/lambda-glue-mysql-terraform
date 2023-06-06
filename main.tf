provider "aws" {
  region     = "us-east-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default" {
    availability_zone = "us-east-1a"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  # security_group_ids = aws_security_group.mysql_sg.id
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "Allow inbound traffic on MySQL port 3306"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Adjust this to limit the source IPs as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role_policy" "lambda_vpc_policy" {
  name = "lambda_vpc_policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda01"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "my_lambda_function" {
  function_name    = var.function_name
  handler          = var.handler
  runtime          = "python3.8"
  timeout          = 10
  memory_size      = 256
  role             = aws_iam_role.iam_for_lambda.arn
  source_code_hash = data.archive_file.lambda.output_base64sha256

  vpc_config {
    subnet_ids         = [aws_default_subnet.default.id]
    security_group_ids = [aws_security_group.mysql_sg.id]
  }  

  # Read the Lambda function code from local disk
  filename         = data.archive_file.lambda.output_path
}

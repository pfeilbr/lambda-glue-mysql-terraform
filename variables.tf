variable "db_name" {
  description = "The name of the database"
  type        = string
  default = "mydb01"
}

variable "username" {
  description = "The username for the database"
  type        = string
  default = "admin"
}

variable "password" {
  description = "The password for the database"
  type        = string
  default = "password01"
  sensitive = true
}  

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  default = "my_function01"
}

variable "handler" {
  description = "The entry point for the Lambda function"
  type        = string
  default = "lambda_function.lambda_handler"
}


variable "lambda_code_path" {
  description = "The path to the Lambda function code"
  type        = string
  default     = "lambda_function_payload.zip"
}
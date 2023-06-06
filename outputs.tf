output "endpoint" {
  description = "The connection endpoint"
  value       = "${aws_db_instance.default.endpoint}"
}

output "arn" {
  description = "The ARN of the RDS instance"
  value       = "${aws_db_instance.default.arn}"
}

output "db_password" {
  description = "The ARN of the RDS instance"
  value       = "${var.password}"
  sensitive = true
}
output "security_group_id" {
  description = "ID do security group"
  value       = aws_security_group.web_server_sg.id
}

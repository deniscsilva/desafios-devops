output "public_ip" {
  description = "IP publico da instancia EC2."
  value       = aws_instance.web_server.public_ip
}

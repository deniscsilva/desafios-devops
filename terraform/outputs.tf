# Output para o IP público da instância
output "public_ip" {
  description = "O endereço de IP público da instância EC2."
  value       = module.ec2_instance.public_ip
}
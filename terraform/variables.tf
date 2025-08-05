# Variável para a região da AWS
variable "aws_region" {
  description = "Região da AWS para provisionar os recursos."
  type        = string
  default     = "us-east-1"
}

# Variável para o IP que terá acesso SSH
variable "ssh_location" {
  description = "O IP ou range de IPs (formato CIDR) para liberar o acesso SSH. Ex: 189.12.34.56/32"
  type        = string
}

# Variável para o nome da chave SSH
variable "key_name" {
  description = "Nome da chave SSH registrada na AWS para acessar a instância."
  type        = string
}

# Variável para o tipo da instância
variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t2.micro"
}

variable "sg_name" {
  description = "Nome do security group"
  type        = string
  default     = "web-server-sg"
}

variable "sg_description" {
  description = "Descrição do security group"
  type        = string
  default     = "Allow HTTP, HTTPS and SSH traffic"
}

variable "ssh_location" {
  description = "IP ou range de IPs (formato CIDR) para permitir acesso SSH."
  type        = string
}

variable "sg_tag_name" {
  description = "Nome da Tag do security group"
  type        = string
  default     = "desafio-sg"
}

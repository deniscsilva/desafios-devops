variable "instance_type" {
  description = "EC2 tipo de instancia."
  type        = string
}

variable "security_group_id" {
  description = "ID do security group para associar à instancia."
  type        = string
}

variable "key_name" {
  description = "Nome da chave .pem para conetar à instancia."
  type        = string
}

variable "instance_tag_name" {
  description = "Nome da Tag para instancia EC2"
  type        = string
  default     = "Desafio-Terraform"
}

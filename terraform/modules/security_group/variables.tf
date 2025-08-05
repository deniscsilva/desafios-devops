variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "web-server-sg"
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
  default     = "Allow HTTP, HTTPS and SSH traffic"
}

variable "ssh_location" {
  description = "The IP or range of IPs (formato CIDR) to allow SSH access."
  type        = string
}

variable "sg_tag_name" {
  description = "Tag name for the security group"
  type        = string
  default     = "desafio-sg"
}

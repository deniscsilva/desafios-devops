variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group to associate with the instance."
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key to access the instance."
  type        = string
}

variable "instance_tag_name" {
  description = "Tag name for the EC2 instance"
  type        = string
  default     = "Desafio-Terraform"
}

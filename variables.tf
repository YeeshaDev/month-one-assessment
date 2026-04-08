variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type_web" {
  description = "Instance type for web and bastion servers"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_db" {
  description = "Instance type for database server"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
  default     = "us_demo_key"
}

variable "my_ip" {
  description = "Your public IP address for bastion SSH access"
  type        = string
}

variable "db_password" {
  description = "Password for PostgreSQL user and dbadmin SSH user"
  type        = string
  sensitive   = true
}

variable "web_password" {
  description = "Password for webadmin SSH user"
  type        = string
  sensitive   = true
}

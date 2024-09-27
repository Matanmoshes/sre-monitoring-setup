variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance (Amazon Linux 2)"
  default     = "ami-0e86e20dae9224db8"  # Ubuntu Server 24.04  
}

variable "allowed_ip" {
  description = "Your IP address to allow SSH access (in CIDR notation)"
  default     = "0.0.0.0/0"  
}

variable "OPENWEATHER_API_KEY" {
  description = "API key for OpenWeather"
  type        = string
}

variable "SMTP_AUTH_PASSWORD" {
  description = "Gmail App Password for SMTP authentication"
  type        = string
  sensitive   = true
}

variable "key_pair_name" {
  description = "Name of the key pair to use for EC2 instance"
  default     = "27-09-24-key"  # change keys if needed
}


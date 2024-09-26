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
  default     = "ami-0c02fb55956c7d316"  
}

variable "key_pair_name" {
  description = "Name of the key pair to use for EC2 instance"
  default     = "your-key-pair"  
}

variable "allowed_ip" {
  description = "Your IP address to allow SSH access (in CIDR notation)"
  default     = "0.0.0.0/0"  
}


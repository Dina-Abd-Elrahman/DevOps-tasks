variable "aws_region" {
  type        = string
  description = "aws region to use for resources"
  default     = "us-east-1"
  sensitive   = false
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable DNS hostname in VPCs"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/24"
}

variable "vpc_subnet1_cidr_block" {
  type        = string
  description = "CIDR block for subnet 1 in VPC"
  default     = "10.0.0.0/24"
}

variable "map_public_ip_on_launch" {
  type        = bool 
  description = "map a public ip address for subnet instances"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "type for EC2 instance"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "company name for resource tagging"
  default     =  "smart_life"
}

variable "project" {
  type        = string
  description = "project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "billing code fore resource tagging"
}
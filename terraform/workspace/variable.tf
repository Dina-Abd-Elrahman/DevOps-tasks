variable "naming_prefix" {
  type        = string
  description = "naming prefix for all resources"
  default     = "globoweb"
}

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
  type        = map(string)
  description = "CIDR block for VPC"
}

variable "vpc_subnet_count" {
  type        = map(number)
  description = "Number of subnets to create"
}

variable "vpc_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR block for subnets 1 in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "map a public ip address for subnet instances"
  default     = true
}

variable "instance_type" {
  type        = map(string)
  description = "type for EC2 instance"
}

variable "instance_count" {
  type        = map(number)
  description = "Number of instances to create"
}

variable "company" {
  type        = string
  description = "company name for resource tagging"
  default     = "smart_life"
}

variable "project" {
  type        = string
  description = "project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "billing code fore resource tagging"
}
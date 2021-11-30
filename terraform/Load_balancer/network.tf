##################################################################################
# PROVIDERS
##################################################################################

 provider "aws" {
  region = var.aws_region
 }

##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

 resource "aws_vpc" "vpc" {            
   cidr_block           = var.vpc_cidr_block          # Defining the CIDR block  
   enable_dns_hostnames = var.enable_dns_hostnames

   tags = local.common_tags
 }
 
# Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "igw" {    
    vpc_id =  aws_vpc.vpc.id    
    tags = local.common_tags           
 }
 
# Create a Public Subnets.
 resource "aws_subnet" "subnet1" {    
   vpc_id =  aws_vpc.vpc.id
   cidr_block = var.vpc_subnets_cidr_block[0]
   map_public_ip_on_launch = var.map_public_ip_on_launch 
   availability_zone = data.aws_availability_zones.available.names[0]

   tags = local.common_tags   
 }

 resource "aws_subnet" "subnet2" {    
   vpc_id =  aws_vpc.vpc.id
   cidr_block = var.vpc_subnets_cidr_block[1]
   map_public_ip_on_launch = var.map_public_ip_on_launch 
   availability_zone = data.aws_availability_zones.available.names[1]

   tags = local.common_tags   
 }

# ROUTING #

# Route table for Public Subnet's
 resource "aws_route_table" "rtb" {    
    vpc_id =  aws_vpc.vpc.id

        route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.igw.id
     }

     tags = local.common_tags
 }


# Route table Association with Public Subnet's
 resource "aws_route_table_association" "rta-subnet1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rtb.id
 }

  resource "aws_route_table_association" "rta-subnet2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.rtb.id
 }

# SECURITY GROUPS #

# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name = "nginx_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block] 
  }

  # outbound internet access
  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}

# Nginx security group 
resource "aws_security_group" "alb-sg" {
  name = "nginx_alb_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # outbound internet access
  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}
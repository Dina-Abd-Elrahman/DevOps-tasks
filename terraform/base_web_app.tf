##################################################################################
# PROVIDERS
##################################################################################

 provider "aws" {
  region = "us-east-1"
 }

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

 resource "aws_vpc" "vpc" {            
   cidr_block       = "10.0.0.0/16"          # Defining the CIDR block  
   instance_tenancy = "default"             # make it a default vpc
 }
 
# Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "igw" {    
    vpc_id =  aws_vpc.vpc.id               
 }
 
# Create a Public Subnets.
 resource "aws_subnet" "publicsubnets" {    
   vpc_id =  aws_vpc.vpc.id
   cidr_block = "10.0.0.0/24"  
   map_public_ip_on_launch = "true"      
 }

# ROUTING #

# Route table for Public Subnet's
 resource "aws_route_table" "rtb" {    
    vpc_id =  aws_vpc.vpc.id

        route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.igw.id
     }
 }



# Route table Association with Public Subnet's
 resource "aws_route_table_association" "rta-subnet1" {
    subnet_id = aws_subnet.subnet1.id
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
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # outbound internet access
  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# INSTANCES #
resource "aws_instance" "nginx1" {
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF
}

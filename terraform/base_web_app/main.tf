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

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

 resource "aws_vpc" "vpc" {            
   cidr_block           = var.vpc_cidr_block          # Defining the CIDR block  
   enable_dns_hostnames = var.enable_dns_hostnames
   # instance_tenancy     = "default"             # make it a default vpc
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
   cidr_block = var.vpc_subnet1_cidr_block
   map_public_ip_on_launch = var.map_public_ip_on_launch  

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

  tags = local.common_tags

}

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html>
<head>
<title>Hello terraform/title>
</head>
<body style=\"background-color:#1F778D\">
<p style=\"text-align: center;\">
<span style=\"color:#FFFFFF;\">
<span style=\"font-size:28px;\">I did it :D </span>
</span>
</p>
</body>
</html>' | sudo tee /usr/share/nginx/html/index.html
EOF

tags = local.common_tags
}

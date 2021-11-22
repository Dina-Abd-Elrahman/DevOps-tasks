
# Provider 
 provider "aws" {
  region = "us-east-1"
 }

# Create the VPC
 resource "aws_vpc" "Main" {            
   cidr_block       = "10.0.0.0/24"          # Defining the CIDR block  
   enable_dns_hostnames = true
   instance_tenancy = "default"             # make it a default vpc
 }
 
# Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "IGW" {    
    vpc_id =  aws_vpc.Main.id               
 }
 
# Create a Public Subnets.
 resource "aws_subnet" "publicsubnets" {    
   vpc_id =  aws_vpc.Main.id
   cidr_block = "10.0.0.128/26"        
 }

# Create a Private Subnet                   
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = "10.0.0.192/26"          
 }

# Route table for Public Subnet's
 resource "aws_route_table" "PublicRT" {    
    vpc_id =  aws_vpc.Main.id
         route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
     }
 }

# Route table for Private Subnet's
 resource "aws_route_table" "PrivateRT" {    
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }

# Route table Association with Public Subnet's
 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }

# Route table Association with Private Subnet's
 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }

 resource "aws_eip" "nateIP" {
   vpc   = true
 }

# Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
 }

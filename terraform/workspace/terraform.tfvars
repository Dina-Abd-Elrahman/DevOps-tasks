project = "web_app"

vpc_cidr_block = {
  Development = "10.0.0.0/16"
  UAT         = "10.1.0.0/16"
  production  = "10.2.0.0/16"
}

vpc_subnet_count = {
  Development = 2
  UAT         = 2
  production  = 2
}

instance_type = {
  Development = "t2.micro"
  UAT         = "t2.small"
  production  = "t2.meduim"
}

instance_count = {
  Development = 2
  UAT         = 4 
  production  = 6
}
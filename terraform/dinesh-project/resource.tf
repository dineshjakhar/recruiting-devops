##Create the VPC
resource "aws_vpc" "test-vpc" {                
  cidr_block       = var.main_vpc_cidr   
  instance_tenancy = "default"
  tags = {
    Name = "Test-VPC"
  }
 }

 ##Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "IGW" {    
    vpc_id =  aws_vpc.test-vpc.id
    tags = {
    Name = "Test-IGW"
  }               
 }

 ##Create a Public Subnets.
 resource "aws_subnet" "publicsubnets" {    
   vpc_id =  aws_vpc.test-vpc.id
   availability_zone = var.availability_zone
   cidr_block = var.public_subnets
   enable_resource_name_dns_a_record_on_launch = true 
   map_public_ip_on_launch = true
   tags = {
    Name = "Public Subnet"
  }  
 }

### Attach IGW rule to default VPC Route Table
resource "aws_default_route_table" "test-rt" {
  default_route_table_id = aws_vpc.test-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }


  tags = {
    Name = "test RT"
  }
}

## Create ec2 Instance
resource "aws_instance" "example" {
     ami = data.aws_ami.amazon-linux-2.id
     instance_type = "t2.micro"
     availability_zone = var.availability_zone
     key_name                    = "dinesh-test"
     security_groups = [ aws_security_group.test_sg.id ]
     subnet_id       = aws_subnet.publicsubnets.id
     iam_instance_profile = aws_iam_instance_profile.instance_profile.id
}


## Create AWS Security Group and define rules
resource "aws_security_group" "test_sg" {
  name        = "test-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http protocol"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["1.1.1.1/32"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["8.8.8.8/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "test-sg"
  }
}

## Creating S3 bucket 
resource "aws_s3_bucket" "apps_bucket" {
    bucket = "dinesh12345test"
    acl = "private"
    versioning {
            enabled = true
    }
  
}
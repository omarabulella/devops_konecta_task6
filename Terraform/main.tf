terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = var.region
}
resource "aws_security_group" "security_group" {
  ingress  {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
     egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags ={
        Name="my-security-group"
    }
}
resource "aws_key_pair" "my_new_key" {
  key_name = var.key_name
  public_key = file(var.key_path)
}
resource "aws_instance" "cicd_machine" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.my_new_key.key_name
  security_groups = [ aws_security_group.security_group.name ]
  associate_public_ip_address = true
  tags = {
    Name="CICD-Machine"
  }
}
resource "aws_instance" "Production_machine" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.my_new_key.key_name
  security_groups = [ aws_security_group.security_group.name ]
  associate_public_ip_address = true
  tags = {
    Name="Production-Machine"
  }
}
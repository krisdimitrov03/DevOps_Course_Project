provider "aws" {
  region = "eu-north-1"
}

data "aws_security_group" "existing_web_sg" {
  filter {
    name   = "group-name"
    values = ["allow_http"]
  }

  filter {
    name   = "vpc-id"
    values = ["vpc-0b521f32b325fb002"]
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.existing_web_sg.id]
  associate_public_ip_address = true
  key_name = "ACCESS_PAIR"

  tags = {
    Name = "DevOps_Course_Project"
  }

  lifecycle {
    prevent_destroy = true
  }
}

terraform {
  backend "s3" {
    bucket         = "your-new-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

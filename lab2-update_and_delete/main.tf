provider "aws" {
  region = "eu-west-1"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

resource "aws_instance" "web" {
  ami           = "ami-0ea0f26a6d50850c5"
  instance_type = "t3.micro"

  root_block_device {
    delete_on_termination = "true"
    volume_size           = "10"
    volume_type           = "gp3"
  }

  tags = {
    Name = "Web Server"
  }
}

provider "aws" {
  region = "<aws_region>"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

resource "aws_instance" "web" {
  ami           = "<ami_id>"
  instance_type = "t3.micro"

  tags = {
    Name = "Web Server"
  }
}

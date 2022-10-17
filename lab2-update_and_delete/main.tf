provider "aws" {
  region = "<aws_region>"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

resource "aws_instance" "web" {
  ami           = "<ami_id>"
  instance_type = "t3.micro"

  # Update web server root disk
  #root_block_device {
  #  delete_on_termination = "true"
  #  volume_size           = "10"
  #  volume_type           = "gp3"
  #}

  tags = {
    Name = "Web Server"
  }
}

provider "aws" {
  region = "<aws_region>"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

module "network" {
  source = "./network"
  vpc_cidr = "vpc_cidr"
  subnet_cidr = "subnet_cidr"
  az = "availability_zone"
}

resource "aws_security_group" "web_traffic" {
  name        = "tf_sg_web_server"
  description = "Allow ssh traffic to web server"
  vpc_id      = module.network.dev_vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "web-server" {
  ami                    = "<ami_id>" # Use Amazon Linux AMI
  instance_type          = "t2.micro"
  subnet_id              = module.network.public_a_subnet_id
  vpc_security_group_ids = [aws_security_group.web_traffic.id]
  key_name = "test_kp"
  user_data = <<EOF
  #!/bin/bash
yum -y install httpd
systemctl enable httpd
systemctl start httpd
echo "First  web server" > /var/www/html/index.html
  EOF
   
  root_block_device {
    delete_on_termination = "true"
    volume_size           = "10"
    volume_type           = "gp2"
  }


  tags = {
    Name   = "Web Server"
    Status = "Dev"
  }
}

output "ec2_public_ip" {
  value = aws_instance.web-server.public_ip
  description = "Web Server Public IP"
}
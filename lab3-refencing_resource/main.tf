provider "aws" {
  region = "eu-west-1"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

resource "aws_vpc" "dev" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "Development VPC"
  }
}

# Reference VPC ID from Subnet creation
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.dev.id 
  cidr_block = "10.1.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-a-10.0.1.0/24"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "Dev Internet Gateway"
  }
}


# We use depends on
resource "aws_route_table" "route_tbl_inet" {
  vpc_id = aws_vpc.dev.id
  depends_on = [
    aws_vpc.dev,
    aws_internet_gateway.igw
  ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Dev route to internet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.route_tbl_inet.id

  depends_on = [
    aws_subnet.public_a,
    aws_internet_gateway.igw
  ]
}
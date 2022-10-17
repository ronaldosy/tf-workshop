provider "aws" {
  region = "<aws_region>"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

resource "aws_vpc" "dev" {
  cidr_block = "<vpc_cidr_block>"

  tags = {
    Name = "Development VPC"
  }
}

# Reference VPC ID from Subnet creation
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.dev.id 
  cidr_block = "<subnet_cidr_block>"
  availability_zone = "<availability_zone>"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "Dev Internet Gateway"
  }
}


# We use depends on
resource "aws_route_table" "route_tbl_inet_igw" {
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
    Name = "Route to Internet via IGW"
  }
}

resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.route_tbl_inet_igw.id

  depends_on = [
    aws_subnet.public_a,
    aws_internet_gateway.igw
  ]
}

output "dev_vpc_id" {
  value = aws_vpc.dev.id
}

output "public_a_subnet_id" {
  value = aws_subnet.public.id
}
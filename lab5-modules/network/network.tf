resource "aws_vpc" "dev" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Development VPC"
  }
}

# Reference VPC ID from Subnet creation
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.dev.id 
  cidr_block = var.vpc_cidr
  availability_zone = var.az
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
    Name = "Public Subnet to Internet"
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

output "dev_vpc_id" {
  value = aws_vpc.dev.id
}

output "public_a_subnet_id"{
  value = aws_subnet.public_a.id
}
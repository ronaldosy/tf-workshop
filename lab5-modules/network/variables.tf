variable "vpc_cidr"{
    type = string
    description = "CIDR Range for VPC"
}

variable "az" {
    type = string
    description = "AWS AZ"
}

variable "subnet_cidr" {
    type = string
    description = "Subnet CIDR Range"
}
variable "region" {
    type = string
  }
  
  variable "vpc_id" {
    type = string
  }
  
  variable "pub_subnet" {
    type = list(string)
  }

variable "ami_id" {
  type = string
}
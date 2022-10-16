variable "region" {
    type = string
  }
  
  variable "vpc_id" {
    type = string
  }
  
  variable "pub_subnet" {
    type = list(string)
  }
  
  variable "ssm_role"{
    type = string
    default = "AccessEC2viaSessionManager"
  }
  
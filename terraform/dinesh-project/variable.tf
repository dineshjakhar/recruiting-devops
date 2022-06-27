variable "main_vpc_cidr" {
    description = "Cidr block range of VPC"
    default = "10.0.0.0/16"
}

variable "access_key" {
    type = string
}

variable "secret_key" {
  type = string
}

variable "public_subnets" {
    default = "10.0.1.0/24"
  
}

variable "availability_zone" {
  default = "us-west-2a"
}


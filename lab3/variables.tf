variable "region" {
  description = "region"
  default = "us-east-1"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet1_cidr" {
    type = string
    default = "10.0.1.0/24"
}

variable "subnet2_cidr" {
    type = string
    default = "10.0.2.0/24"
}

variable "prefix" {
    type = string
    default = "lab3"
}

variable "bucket_name" {
    type = string
    default = "cscie49-terraform-state-bucket"
}

variable "db_password" {
    type = string
    default = "Password123"
}
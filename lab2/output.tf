output "lab1_vpc_id" {
  value = data.aws_vpc.lab1_vpc.id
}

output "lab1_subnet1_id" {
  value = data.aws_subnet.lab1_subnet.id
}

output "lab1_subnet1_cidr" {
  value = data.aws_subnet.lab1_subnet.cidr_block
}

output "lab1_sg_id" {
  value = data.aws_security_group.lab1_sg.id
}

output "lab1_kms_id" {
  value = data.aws_kms_key.lab1_kms.id
}

output "lab1_key_pair" {
    value = data.aws_key_pair.lab1_key_pair.public_key
}


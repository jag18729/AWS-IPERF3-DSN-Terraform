# Public IPs
output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = aws_instance.bastion.public_ip
}

# Private IPs
output "client_private_ip" {
  description = "Private IP of iperf3 client"
  value       = aws_instance.client.private_ip
}

output "canberra_server_private_ip" {
  description = "Private IP of Canberra server"
  value       = aws_instance.server_canberra.private_ip
}

output "barstow_server_private_ip" {
  description = "Private IP of Barstow server"
  value       = aws_instance.server_barstow.private_ip
}

# Connection Commands
output "bastion_ssh_command" {
  description = "Command to SSH into bastion host"
  value       = "ssh -i ~/.ssh/iperf3-key ec2-user@${aws_instance.bastion.public_ip}"
}

output "client_ssh_command" {
  description = "Command to SSH into client through bastion"
  value       = "ssh -i ~/.ssh/iperf3-key -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@${aws_instance.client.private_ip}"
}

# Termination Date
output "instance_termination_date" {
  description = "Date when instances will be terminated"
  value       = timeadd(timestamp(), "720h")
}

# VPC Information
output "vpc_ids" {
  description = "IDs of created VPCs"
  value = {
    pasadena = aws_vpc.pasadena.id
    canberra = aws_vpc.canberra.id
    barstow  = aws_vpc.barstow.id
  }
}

# Security Group Information
output "security_group_ids" {
  description = "IDs of created security groups"
  value = {
    bastion  = aws_security_group.bastion.id
    client   = aws_security_group.client.id
    canberra = aws_security_group.server_canberra.id
    barstow  = aws_security_group.server_barstow.id
  }
}

# Peering Connection IDs
output "vpc_peering_connection_ids" {
  description = "IDs of VPC peering connections"
  value = {
    pasadena_canberra = aws_vpc_peering_connection.pasadena_canberra.id
    pasadena_barstow  = aws_vpc_peering_connection.pasadena_barstow.id
  }
}

# Instance IDs
output "instance_ids" {
  description = "IDs of created EC2 instances"
  value = {
    bastion  = aws_instance.bastion.id
    client   = aws_instance.client.id
    canberra = aws_instance.server_canberra.id
    barstow  = aws_instance.server_barstow.id
  }
}
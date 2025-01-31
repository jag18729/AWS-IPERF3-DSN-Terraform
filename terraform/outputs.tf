output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "client_private_ip" {
  value = aws_instance.client.private_ip
}

output "spain_server_private_ip" {
  value = aws_instance.server_spain.private_ip
}

output "canberra_server_private_ip" {
  value = aws_instance.server_canberra.private_ip
}

output "barstow_server_private_ip" {
  value = aws_instance.server_barstow.private_ip
}

output "connection_command" {
  value = "ssh -i ~/.ssh/your-key-name -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@${aws_instance.client.private_ip}"
}
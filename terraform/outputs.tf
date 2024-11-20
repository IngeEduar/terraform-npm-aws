output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.docker_server.public_ip
}

output "private_key_file" {
  description = "Path to the generated private key"
  value       = local_file.private_key.filename
}

output "repository_url" {
  description = "Git repository used in the instance"
  value       = var.repository_url
}

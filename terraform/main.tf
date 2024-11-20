# Generar un par de llaves SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Crear un par de claves en AWS
resource "aws_key_pair" "ssh_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Crear una instancia EC2
resource "aws_instance" "docker_server" {
  ami           = "ami-0aa2b7722dc1b5612" # Ubuntu Server 22.04
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh_key_pair.key_name

  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get install -y docker.io docker-compose git
            systemctl start docker
            systemctl enable docker

            # Clonar el repositorio
            git clone ${var.repository_url} /opt/mi-aplicacion
            cd /opt/mi-aplicacion/Docker-node
            docker-compose up -d
  EOF
}

# Guardar la llave privada localmente
resource "local_file" "private_key" {
  filename = local.ssh_key_filename
  content  = tls_private_key.ssh_key.private_key_pem
  file_permission = "0600"
}

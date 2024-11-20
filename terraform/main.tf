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

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOF
            #!/bin/bash
            set -e  # Terminar el script si hay un error

            # Actualizar paquetes
            apt-get update -y
            
            # Instalar dependencias necesarias
            apt-get install -y apt-transport-https ca-certificates curl software-properties-common
            
            # Agregar clave y repositorio de Docker
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
            add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
            
            # Instalar Docker
            apt-get update -y
            apt-get install -y docker-ce
            
            # Clonar el repositorio
            mkdir -p /services/npm-portainer
            git clone ${var.repository_url} /services/npm-portainer
            cd /services/npm-portainer/npm
            
            # Iniciar los contenedores
            sudo docker compose up -d
  EOF
}

# Guardar la llave privada localmente
resource "local_file" "private_key" {
  filename = local.ssh_key_filename
  content  = tls_private_key.ssh_key.private_key_pem
  file_permission = "0600"
}

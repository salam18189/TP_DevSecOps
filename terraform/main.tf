provider "aws" {
  region = "eu-north-1"
  # Ne mets JAMAIS d'access_key ou secret_key ici !
}

# 1. Recherche de l'AMI Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  owners = ["099720109477"] 
}

# 2. Création d'un Groupe de Sécurité
resource "aws_security_group" "sg_tp" {
  name        = "sg_tp_devops"
  description = "Autoriser SSH, Sonar, Grafana, Prometheus"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Création de la VM
resource "aws_instance" "tp_nodes" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "salam"

  vpc_security_group_ids = [aws_security_group.sg_tp.id]

  tags = {
    Name = "Serveur-TP"
  }
}

# 4. Affichage de l'IP
output "instance_ip" {
  value = aws_instance.tp_nodes.public_ip
}
# Configuração de AWS Provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Configuração de VPC

resource "aws_vpc" "vpc-tf" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-bubbles"
  }
}

#Subnets
resource "aws_subnet" "subnet-public" {
  vpc_id     = aws_vpc.vpc-tf.id
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = "subnet-public"
  }
}

resource "aws_subnet" "subnet-private" {
  vpc_id     = aws_vpc.vpc-tf.id
  cidr_block = "10.0.0.128/25"

  tags = {
    Name = "subnet-private"
  }
}

#Security groups
resource "aws_security_group" "public_security_group" {
  name   = "public_security_group"
  vpc_id = aws_vpc.vpc-tf.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite tráfego HTTP de todos os endereços IP
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite tráfego SSH de todos os endereços IP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite tráfego HTTPS de todos os endereços IP
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Permitir todo o tráfego
    cidr_blocks = ["0.0.0.0/0"] # Permitir todo o tráfego de saída
  }

}

resource "aws_security_group" "private_security_group" {
  name   = "security-group"
  vpc_id = aws_vpc.vpc-tf.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite tráfego HTTP de todos os endereços IP
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite tráfego SSH de todos os endereços IP
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite tráfego HTTPS de todos os endereços IP
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite tráfego HTTPS de todos os endereços IP
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Permitir todo o tráfego
    cidr_blocks = ["0.0.0.0/0"] # Permitir todo o tráfego de saída
  }

}

resource "aws_instance" "gateway_bubbles" {
  ami                         = "ami-04b70fa74e45c3917"
  instance_type               = "t2.micro"
  key_name                    = "myssh"
  subnet_id                   = aws_subnet.subnet-public.id
  associate_public_ip_address = true # Habilita a atribuição automática de IP público

  vpc_security_group_ids = [aws_security_group.public_security_group.id]

  provisioner "file" {
    source      = "./gatewayconfig.sh" # Caminho local do seu script
    destination = "/home/ubuntu/executable/gatewayconfig.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu" # Ou o usuário SSH da sua instância
      private_key = var.private_key
      host        = self.public_ip # Ou self.private_ip para uma instância em uma VPC
    }                              # Destino na instância
  }
  provisioner "file" {
    source      = "./frontconfig.sh" # Caminho local do seu script
    destination = "/home/ubuntu/executable/frontconfig.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu" # Ou o usuário SSH da sua instância
      private_key = var.private_key
      host        = self.public_ip # Ou self.private_ip para uma instância em uma VPC
    }                              # Destino na instância
  }
  provisioner "file" {
    source      = "./bdconfig.sh" # Caminho local do seu script
    destination = "/home/ubuntu/executable/bdconfig.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu" # Ou o usuário SSH da sua instância
      private_key = var.private_key
      host        = self.public_ip # Ou self.private_ip para uma instância em uma VPC
    }                              # Destino na instância
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/executable/gatewayconfig.sh", # Concede permissões de execução ao script
      "/home/ubuntu/executable/gatewayconfig.sh",          # Executa o script
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu" # Ou o usuário SSH da sua instância
      private_key = var.private_key
      host        = self.public_ip # Ou self.private_ip para uma instância em uma VPC
    }
  }

  tags = {
    Name = "Gateway Bubbles"
  }

}
resource "aws_instance" "frontend1_bubbles" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "myssh"
  subnet_id     = aws_subnet.subnet-public.id


  vpc_security_group_ids = [aws_security_group.public_security_group.id]

  tags = {
    Name = "Front1"
  }

}
resource "aws_instance" "frontend2_bubbles" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "myssh"
  subnet_id     = aws_subnet.subnet-public.id


  vpc_security_group_ids = [aws_security_group.public_security_group.id]

  tags = {
    Name = "Front2"
  }

}
resource "aws_instance" "backload_bubbles" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "myssh"
  subnet_id     = aws_subnet.subnet-private.id


  vpc_security_group_ids = [aws_security_group.private_security_group.id]


  tags = {
    Name = "Backload"
  }

}
resource "aws_instance" "bd_instance" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "myssh"
  subnet_id     = aws_subnet.subnet-private.id


  vpc_security_group_ids = [aws_security_group.private_security_group.id]

  tags = {
    Name = "BD Instance"
  }

}
resource "aws_instance" "backend1_bubbles" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "myssh"
  subnet_id     = aws_subnet.subnet-private.id


  vpc_security_group_ids = [aws_security_group.private_security_group.id]

  tags = {
    Name = "Back1"
  }

}
resource "aws_instance" "backend2_bubbles" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "myssh"
  subnet_id     = aws_subnet.subnet-private.id


  vpc_security_group_ids = [aws_security_group.private_security_group.id]

  tags = {
    Name = "Back2"
  }

}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc-tf.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "my-public-route-table"
  }
}
resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.subnet-public.id
  route_table_id = aws_route_table.public_route_table.id

}

# Recursos Nat Gateway
resource "aws_eip" "my_eip" {
  domain = "vpc" # Usar domain nas configurações mais atuais.
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }
  tags = {
    Name = "my-private-route-table"
  }
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.subnet-private.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.subnet-public.id
  tags = {
    Name = "my-nat-gateway"
  }
}

resource "aws_network_acl" "public_network_acl" {
  vpc_id = aws_vpc.vpc-tf.id

  subnet_ids = [aws_subnet.subnet-public.id]
  tags = {
    Name = "public-network-acl"
  }
}

resource "aws_network_acl" "private_network_acl" {
  vpc_id = aws_vpc.vpc-tf.id

  subnet_ids = [aws_subnet.subnet-private.id]
  tags = {
    Name = "private-network-acl"
  }
}

resource "aws_network_acl_rule" "public_allow_all_inbound_rule" {
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_allow_all_outbound_rule" {
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = 100
  protocol       = "tcp"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_80" {
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = 200
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "public_80_outbound" {
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = 200
  protocol       = "tcp"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "public_443" {
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = 300
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_443_outbound" {
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = 300
  protocol       = "tcp"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_22" {
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = 400
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_22_outbound" {
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = 400
  protocol       = "tcp"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "private_inbound_rule_all" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}
resource "aws_network_acl_rule" "private_outbound_rule_all" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_to_public_inbound_rule" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 150
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/25"
  from_port      = 3000
  to_port        = 65535
}
resource "aws_network_acl_rule" "private_to_public_outbound_rule" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 150
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/25"
  from_port      = 3000
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_80" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 200
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "private_80_outbound" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 200
  protocol       = "tcp"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "private_443" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 300
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "private_443_outbound" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 300
  protocol       = "tcp"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "private_22" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 400
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "private_22_outbound" {
  network_acl_id = aws_network_acl.private_network_acl.id
  rule_number    = 400
  protocol       = "tcp"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

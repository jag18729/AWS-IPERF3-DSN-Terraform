# PASADENA VPC (Client + Bastion)
resource "aws_vpc" "pasadena" {
  provider             = aws.pasadena
  cidr_block           = var.vpc_cidrs["pasadena"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-pasadena-vpc"
  })
}

resource "aws_subnet" "pasadena" {
  provider          = aws.pasadena
  vpc_id            = aws_vpc.pasadena.id
  cidr_block        = var.vpc_cidrs["pasadena"]
  availability_zone = "us-west-2a"

  tags = merge(var.tags, {
    Name = "${var.project_name}-pasadena-subnet"
  })
}

resource "aws_internet_gateway" "pasadena" {
  provider = aws.pasadena
  vpc_id   = aws_vpc.pasadena.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-pasadena-igw"
  })
}

resource "aws_route_table" "pasadena" {
  provider = aws.pasadena
  vpc_id   = aws_vpc.pasadena.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pasadena.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-pasadena-rt"
  })
}

resource "aws_route_table_association" "pasadena" {
  provider       = aws.pasadena
  subnet_id      = aws_subnet.pasadena.id
  route_table_id = aws_route_table.pasadena.id
}

# SPAIN VPC (Server0)
resource "aws_vpc" "spain" {
  provider             = aws.spain
  cidr_block           = var.vpc_cidrs["spain"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-spain-vpc"
  })
}

resource "aws_subnet" "spain" {
  provider          = aws.spain
  vpc_id            = aws_vpc.spain.id
  cidr_block        = var.vpc_cidrs["spain"]
  availability_zone = "eu-south-2a"

  tags = merge(var.tags, {
    Name = "${var.project_name}-spain-subnet"
  })
}

resource "aws_internet_gateway" "spain" {
  provider = aws.spain
  vpc_id   = aws_vpc.spain.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-spain-igw"
  })
}

resource "aws_route_table" "spain" {
  provider = aws.spain
  vpc_id   = aws_vpc.spain.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spain.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-spain-rt"
  })
}

resource "aws_route_table_association" "spain" {
  provider       = aws.spain
  subnet_id      = aws_subnet.spain.id
  route_table_id = aws_route_table.spain.id
}

# CANBERRA VPC (Server1)
resource "aws_vpc" "canberra" {
  provider             = aws.canberra
  cidr_block           = var.vpc_cidrs["canberra"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-canberra-vpc"
  })
}

resource "aws_subnet" "canberra" {
  provider          = aws.canberra
  vpc_id            = aws_vpc.canberra.id
  cidr_block        = var.vpc_cidrs["canberra"]
  availability_zone = "ap-southeast-2a"

  tags = merge(var.tags, {
    Name = "${var.project_name}-canberra-subnet"
  })
}

resource "aws_internet_gateway" "canberra" {
  provider = aws.canberra
  vpc_id   = aws_vpc.canberra.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-canberra-igw"
  })
}

resource "aws_route_table" "canberra" {
  provider = aws.canberra
  vpc_id   = aws_vpc.canberra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.canberra.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-canberra-rt"
  })
}

resource "aws_route_table_association" "canberra" {
  provider       = aws.canberra
  subnet_id      = aws_subnet.canberra.id
  route_table_id = aws_route_table.canberra.id
}

# BARSTOW VPC (Server2)
resource "aws_vpc" "barstow" {
  provider             = aws.barstow
  cidr_block           = var.vpc_cidrs["barstow"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-barstow-vpc"
  })
}

resource "aws_subnet" "barstow" {
  provider          = aws.barstow
  vpc_id            = aws_vpc.barstow.id
  cidr_block        = var.vpc_cidrs["barstow"]
  availability_zone = "us-west-1a"

  tags = merge(var.tags, {
    Name = "${var.project_name}-barstow-subnet"
  })
}

resource "aws_internet_gateway" "barstow" {
  provider = aws.barstow
  vpc_id   = aws_vpc.barstow.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-barstow-igw"
  })
}

resource "aws_route_table" "barstow" {
  provider = aws.barstow
  vpc_id   = aws_vpc.barstow.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.barstow.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-barstow-rt"
  })
}

resource "aws_route_table_association" "barstow" {
  provider       = aws.barstow
  subnet_id      = aws_subnet.barstow.id
  route_table_id = aws_route_table.barstow.id
}

# SECURITY GROUPS
# Bastion Security Group
resource "aws_security_group" "bastion" {
  provider    = aws.pasadena
  name        = "${var.project_name}-bastion-sg"
  description = "Security group for Bastion host"
  vpc_id      = aws_vpc.pasadena.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", var.allowed_ip)]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [format("%s/32", var.allowed_ip)]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-bastion-sg"
  })
}

# Client Security Group
resource "aws_security_group" "client" {
  provider    = aws.pasadena
  name        = "${var.project_name}-client-sg"
  description = "Security group for iPerf3 client"
  vpc_id      = aws_vpc.pasadena.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  ingress {
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-client-sg"
  })
}

# Spain Server Security Group
resource "aws_security_group" "server_spain" {
  provider    = aws.spain
  name        = "${var.project_name}-server-spain-sg"
  description = "Security group for iPerf3 server in Spain"
  vpc_id      = aws_vpc.spain.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidrs["pasadena"]]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  ingress {
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-server-spain-sg"
  })
}

# Canberra Server Security Group
resource "aws_security_group" "server_canberra" {
  provider    = aws.canberra
  name        = "${var.project_name}-server-canberra-sg"
  description = "Security group for iPerf3 server in Canberra"
  vpc_id      = aws_vpc.canberra.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidrs["pasadena"]]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  ingress {
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-server-canberra-sg"
  })
}

# Barstow Server Security Group
resource "aws_security_group" "server_barstow" {
  provider    = aws.barstow
  name        = "${var.project_name}-server-barstow-sg"
  description = "Security group for iPerf3 server in Barstow"
  vpc_id      = aws_vpc.barstow.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidrs["pasadena"]]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  ingress {
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-server-barstow-sg"
  })
}
# VPC PEERING CONNECTIONS

# Pasadena to Spain
resource "aws_vpc_peering_connection" "pasadena_spain" {
  provider    = aws.pasadena
  vpc_id      = aws_vpc.pasadena.id
  peer_vpc_id = aws_vpc.spain.id
  peer_region = "eu-south-2"
  auto_accept = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-pasadena-spain-peer"
  })
}

resource "aws_vpc_peering_connection_accepter" "spain_accept" {
  provider                  = aws.spain
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_spain.id
  auto_accept              = true
}

# Pasadena to Canberra
resource "aws_vpc_peering_connection" "pasadena_canberra" {
  provider    = aws.pasadena
  vpc_id      = aws_vpc.pasadena.id
  peer_vpc_id = aws_vpc.canberra.id
  peer_region = "ap-southeast-2"
  auto_accept = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-pasadena-canberra-peer"
  })
}

resource "aws_vpc_peering_connection_accepter" "canberra_accept" {
  provider                  = aws.canberra
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_canberra.id
  auto_accept              = true
}

# Pasadena to Barstow
resource "aws_vpc_peering_connection" "pasadena_barstow" {
  provider    = aws.pasadena
  vpc_id      = aws_vpc.pasadena.id
  peer_vpc_id = aws_vpc.barstow.id
  peer_region = "us-west-1"
  auto_accept = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-pasadena-barstow-peer"
  })
}

resource "aws_vpc_peering_connection_accepter" "barstow_accept" {
  provider                  = aws.barstow
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_barstow.id
  auto_accept              = true
}

# Add peering routes to route tables
# Pasadena routes
resource "aws_route" "pasadena_to_spain" {
  provider                  = aws.pasadena
  route_table_id            = aws_route_table.pasadena.id
  destination_cidr_block    = var.vpc_cidrs["spain"]
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_spain.id
}

resource "aws_route" "pasadena_to_canberra" {
  provider                  = aws.pasadena
  route_table_id            = aws_route_table.pasadena.id
  destination_cidr_block    = var.vpc_cidrs["canberra"]
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_canberra.id
}

resource "aws_route" "pasadena_to_barstow" {
  provider                  = aws.pasadena
  route_table_id            = aws_route_table.pasadena.id
  destination_cidr_block    = var.vpc_cidrs["barstow"]
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_barstow.id
}

# Spain routes
resource "aws_route" "spain_to_pasadena" {
  provider                  = aws.spain
  route_table_id            = aws_route_table.spain.id
  destination_cidr_block    = var.vpc_cidrs["pasadena"]
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_spain.id
}

# Canberra routes
resource "aws_route" "canberra_to_pasadena" {
  provider                  = aws.canberra
  route_table_id            = aws_route_table.canberra.id
  destination_cidr_block    = var.vpc_cidrs["pasadena"]
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_canberra.id
}

# Barstow routes
resource "aws_route" "barstow_to_pasadena" {
  provider                  = aws.barstow
  route_table_id            = aws_route_table.barstow.id
  destination_cidr_block    = var.vpc_cidrs["pasadena"]
  vpc_peering_connection_id = aws_vpc_peering_connection.pasadena_barstow.id
}

# EC2 INSTANCES

# Key pair for all instances
resource "aws_key_pair" "ssh_key" {
  provider   = aws.pasadena
  key_name   = "${var.project_name}-key"
  public_key = var.ssh_public_key
}

# Bastion Host
resource "aws_instance" "bastion" {
  provider          = aws.pasadena
  ami               = var.amis["us-west-2"]
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.pasadena.id
  security_groups   = [aws_security_group.bastion.id]
  key_name          = aws_key_pair.ssh_key.key_name
  source_dest_check = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-bastion"
  })
}

# Client Instance
resource "aws_instance" "client" {
  provider          = aws.pasadena
  ami               = var.amis["us-west-2"]
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.pasadena.id
  security_groups   = [aws_security_group.client.id]
  key_name          = aws_key_pair.ssh_key.key_name
  source_dest_check = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-client"
  })
}

# Spain Server
resource "aws_instance" "server_spain" {
  provider          = aws.spain
  ami               = var.amis["eu-south-2"]
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.spain.id
  security_groups   = [aws_security_group.server_spain.id]
  key_name          = aws_key_pair.ssh_key.key_name
  source_dest_check = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-server-spain"
  })
}

# Canberra Server
resource "aws_instance" "server_canberra" {
  provider          = aws.canberra
  ami               = var.amis["ap-southeast-2"]
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.canberra.id
  security_groups   = [aws_security_group.server_canberra.id]
  key_name          = aws_key_pair.ssh_key.key_name
  source_dest_check = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-server-canberra"
  })
}

# Barstow Server
resource "aws_instance" "server_barstow" {
  provider          = aws.barstow
  ami               = var.amis["us-west-1"]
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.barstow.id
  security_groups   = [aws_security_group.server_barstow.id]
  key_name          = aws_key_pair.ssh_key.key_name
  source_dest_check = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-server-barstow"
  })
}
# [Resource: aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

## Primary VPC setup main resource
resource "aws_vpc" "primary_vpc" {
  cidr_block           = var.primary_vpc_cidr
  provider             = aws.primary
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Primary-VPC-${var.primary}"
  }
}

## Secondary VPC setup main resource
resource "aws_vpc" "secondary_vpc" {
  cidr_block           = var.secondary_vpc_cidr
  provider             = aws.secondary
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Secondary-VPC-${var.primary}"
  }
}

## Third VPC setup main resource
resource "aws_vpc" "third_vpc" {
  cidr_block           = var.third_vpc_cidr
  provider             = aws.third
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Third-VPC-${var.third}"
  }
}

## Subnet Setup
## [Resource: aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)

# Subnet Setup for VPC for primary region
resource "aws_subnet" "primary_subnet" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.primary_subnet_cidr
  availability_zone       = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Primary-Subnet-${var.primary}"
    Environment = "Day15-task"
  }

}

# Subnet Setup for VPC for secondary region
resource "aws_subnet" "secondary_subnet" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary_vpc.id
  cidr_block              = var.secondary_subnet_cidr
  availability_zone       = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Secondary-Subnet-${var.secondary}"
    Environment = "Day15-Task"
  }

}

# Subnet Setup for VPC for Third region
resource "aws_subnet" "third_subnet" {
  provider                = aws.third
  vpc_id                  = aws_vpc.third_vpc.id
  cidr_block              = var.third_subnet_cidr
  availability_zone       = data.aws_availability_zones.third.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Third-subnet-${var.third}"
    Environment = "Day15-Task"
  }
}


# Internet Gate Setup 
# Primary Region Internet Gateway
resource "aws_internet_gateway" "primary_igw" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  tags = {
    Name        = "Primary-IGW-${var.primary}"
    Environment = "Day15-task"
  }
}


# Secondary Region Internet Gateway
resource "aws_internet_gateway" "secondary_igw" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary_vpc.id

  tags = {
    Name        = "Secondary-IGW-${var.secondary}"
    Environment = "Day15-task"
  }
}

# Third Region Internet Gateway
resource "aws_internet_gateway" "third_igw" {
  provider = aws.third
  vpc_id   = aws_vpc.third_vpc.id

  tags = {
    Name        = "Primary-IGW-${var.third}"
    Environment = "Day15-task"
  }
}

# Route Table
# Route Table for Primary Region

resource "aws_route_table" "primary_rt" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }

  tags = {
    Name        = "Primary-Route-Table"
    Environment = "Day15-task"
  }
}


# Route Table for Secondary Region

resource "aws_route_table" "secondary_rt" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }

  tags = {
    Name        = "Secondary-Route-Table"
    Environment = "Day15-task"
  }
}


# Route Table for Third Region

resource "aws_route_table" "third_rt" {
  provider = aws.third
  vpc_id   = aws_vpc.third_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.third_igw.id
  }

  tags = {
    Name        = "Third-Route-Table"
    Environment = "Day15-task"
  }
}


# Route Table Association
## Route Table Association for Primary Region
resource "aws_route_table_association" "primary_rta" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_rt.id
}

## Route Table Association for Secondary Region
resource "aws_route_table_association" "secondary_rta" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_rt.id
}

## Route Table Association for Third Region
resource "aws_route_table_association" "third_rta" {
  provider       = aws.third
  subnet_id      = aws_subnet.third_subnet.id
  route_table_id = aws_route_table.third_rt.id
}

# =====================================================
# PRIMARY ↔ SECONDARY PEERING
# =====================================================

# VPC Peering Connection
# VPC Peering Connection (Requester side - Primary VPC)
# Mandatory Resource
# A to B
resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider    = aws.primary
  vpc_id      = aws_vpc.primary_vpc.id
  peer_vpc_id = aws_vpc.secondary_vpc.id
  peer_region = var.secondary

  tags = {
    Name        = "Primary-to-Secondary-Peering"
    Environment = "Day15-Task"
    Purpose     = "VPC-Peering-Task"
    Side        = "Requester"
  }
}

# VPC Peering Connection Accepter (Accepter side - Secondary VPC)
# B to A
resource "aws_vpc_peering_connection_accepter" "secondary_region_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true

  tags = {
    Name        = "Secondary_Peering-Accepter"
    Environment = "Day15-task"
    Purpose     = "VPC-Peering-Task"
    Side        = "Accepter"
  }
}

# =====================================================
# SECONDARY ↔ TERTIARY PEERING
# =====================================================

resource "aws_vpc_peering_connection" "secondary_to_third" {
  provider    = aws.secondary
  vpc_id      = aws_vpc.secondary_vpc.id
  peer_vpc_id = aws_vpc.third_vpc.id
  peer_region = var.third
  auto_accept = false

  tags = {
    Name        = "Secondary-to-Third-Peering"
    Environment = "Day15-Task"
    Purpose     = "VPC-Peering-Task"
    Side        = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "third_accept_secondary" {
  provider                  = aws.third
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_third.id
  auto_accept               = true

  tags = {
    Name        = "Third_Peering-Accepter"
    Environment = "Day15-task"
    Purpose     = "VPC-Peering-Task"
    Side        = "Accepter"
  }
}

# =====================================================
# TERTIARY ↔ PRIMARY PEERING
# =====================================================

resource "aws_vpc_peering_connection" "third_to_primary" {
  provider    = aws.third
  vpc_id      = aws_vpc.third_vpc.id
  peer_vpc_id = aws_vpc.primary_vpc.id
  peer_region = var.primary
  auto_accept = false

  tags = {
    Name        = "Third-to-Primary-Peering"
    Environment = "Day15-task"
    Purpose     = "VPC-Peering-Task"
    Side        = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "primary_accept_third" {
  provider                  = aws.primary
  vpc_peering_connection_id = aws_vpc_peering_connection.third_to_primary.id
  auto_accept               = true

  tags = {
    Name        = "Primary-Accepter"
    Environment = "Day15-task"
    Purpose     = "VPC-Peering-Task"
    Side        = "Accepter"
  }
}

##########################################################

# Routes
# Primary Routes 1 -> primary to secondary (A to B)
resource "aws_route" "primary_to_secondary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_region_accepter]
}

# Primary Routes 2 -> primary to third
resource "aws_route" "primary_to_third" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = var.third_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.third_to_primary.id

  depends_on = [aws_vpc_peering_connection_accepter.primary_accept_third]
}

# Secondary Route 1 -> secondary to primary (B to A)
resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_region_accepter]
}

# Secondary Route 2 -> secondary to third (B to C)
resource "aws_route" "secondary_to_third" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = var.third_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_third.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_region_accepter]
}

# Third Route 1 -> third to primary (C to A)
resource "aws_route" "third_to_primary" {
  provider                  = aws.third
  route_table_id            = aws_route_table.third_rt.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.third_to_primary.id

  depends_on = [aws_vpc_peering_connection_accepter.primary_accept_third]
}

# Third Route 2 -> third to secondary (C to B)
resource "aws_route" "third_to_secondary" {
  provider                  = aws.third
  route_table_id            = aws_route_table.third_rt.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_third.id

  depends_on = [aws_vpc_peering_connection_accepter.third_accept_secondary]
}

##########################################################

# Security Group
# Security Group for Primary VPC + EC2 instance connecting with secondary region
resource "aws_security_group" "primary_sg" {
  provider    = aws.primary
  name        = "primary-vpc-sg"
  description = "Security group for Primary VPC instance"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr] # by ping protocol
  }

  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  ingress {
    description = "ICMP from Third VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.third_vpc_cidr]
  }

  ingress {
    description = "All traffic from Third VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.third_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Primary-VPC-SG"
    Environment = "Day15"
  }
}

# Security Group for Secondary VPC + EC2 instance connecting with Primary
resource "aws_security_group" "secondary_sg" {
  provider    = aws.secondary
  name        = "secondary-vpc-sg"
  description = "Security group for secondary VPC instance"
  vpc_id      = aws_vpc.secondary_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr] # by ping protocol
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  # ingress - Incoming traffic that enters your network or resource. - inbound rules
  ingress {
    description = "ICMP from Third VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.third_vpc_cidr]
  }

  ingress {
    description = "All traffic from the Third VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.third_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Secondary-VPC-SG"
    Environment = "Day15-task"
  }
}

# Security Group for Third VPC + EC2 Instance
resource "aws_security_group" "third_sg" {
  provider    = aws.third
  name        = "third-vpc-sg"
  description = "Security group for third VPC instance"
  vpc_id      = aws_vpc.third_vpc.id

  ingress {
    description = "SHH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Third-VPC-SG"
    Environment = "Day15-Challenge"
  }
}


## EC2 Instance
# EC2 Instance for Primary VPC
resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.primary_sg.id]
  key_name               = var.primary_key_name

  user_data = local.primary_user_data

  tags = {
    Name        = "Primary-VPC-Instance"
    Environment = "Day15-Task"
    Region      = var.primary
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondary_region_accepter]
}

# EC2 Instance for Secondary VPC
resource "aws_instance" "secondary_instance" {
  provider               = aws.secondary
  ami                    = data.aws_ami.secondary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.secondary_subnet.id
  vpc_security_group_ids = [aws_security_group.secondary_sg.id]
  key_name               = var.secondary_key_name

  user_data = local.secondary_user_data

  tags = {
    Name        = "Secondary-VPC-Instance"
    Environment = "Day15-Task"
    Region      = var.secondary
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondary_region_accepter]
}

# EC2 Instance for Third VPC
resource "aws_instance" "third_instance" {
  provider               = aws.third
  ami                    = data.aws_ami.third_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.third_subnet.id
  vpc_security_group_ids = [aws_security_group.third_sg.id]
  key_name               = var.third_key_name

  tags = {
    Name        = "Third-VPC-Instance"
    Environment = "Day15-Task"
    Region      = var.third
  }
}



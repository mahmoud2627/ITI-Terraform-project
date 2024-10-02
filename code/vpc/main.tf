# Creat VPC
resource "aws_vpc" "vpc1" {
  cidr_block = var.cidr
  tags = {
    Name = "iti-vpc" 
  }
}

# Create internet gatway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "igw"
  }
}


# Creat public route table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "pub_rt"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "pubrt_sub1" {
  subnet_id      = var.pub_sub1_id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pubrt_sub2" {
  subnet_id      = var.pub_sub2_id
  route_table_id = aws_route_table.pub_rt.id
}

# Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"
}


# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.pub_sub1_id
}


# Route Table for Private Subnet
resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "priv_rt"
  }
}

# Route Table Association for Private Subnet
resource "aws_route_table_association" "privrt_sub1" {
  subnet_id      = var.priv_sub1_id
  route_table_id = aws_route_table.priv_rt.id
}

resource "aws_route_table_association" "privrt_sub2" {
  subnet_id      = var.priv_sub2_id
  route_table_id = aws_route_table.priv_rt.id
}


# Public EC2 Security Group: Allow SSH and HTTP/HTTPS from dynamic map variable
resource "aws_security_group" "pub_sg" {
  vpc_id = aws_vpc.vpc1.id

  # Dynamic rule for SSH and HTTP based on the map variable
  dynamic "ingress" {
    for_each = var.security_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value.cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "pub_sg"
  }
}


# Private EC2: Allow HTTP from Public EC2 only
resource "aws_security_group" "priv_sg" {
  vpc_id = aws_vpc.vpc1.id

  # Dynamic rule for SSH and HTTP based on the map variable
  dynamic "ingress" {
    for_each = var.security_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      security_groups = [aws_security_group.pub_sg.id] # Allow from Public EC2
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    Name = "priv_sg"
  }
}

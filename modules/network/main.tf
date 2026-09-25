# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "main-vpc" }
}

# Subnets AZ1
resource "aws_subnet" "dashboard_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dashboard_subnet_az1
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = { Name = "dashboard-az1" }
}

resource "aws_subnet" "backend_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.backend_subnet_az1
  availability_zone       = var.az1
  map_public_ip_on_launch = false   # ← privé
  tags = { Name = "backend-az1" }
}

resource "aws_subnet" "db_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_az1
  availability_zone = var.az1
  tags = { Name = "db-az1" }
}

# Subnets AZ2
resource "aws_subnet" "dashboard_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dashboard_subnet_az2
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = { Name = "dashboard-az2" }
}

resource "aws_subnet" "backend_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.backend_subnet_az2
  availability_zone       = var.az2
  map_public_ip_on_launch = false   # ← privé
  tags = { Name = "backend-az2" }
}

resource "aws_subnet" "db_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_az2
  availability_zone = var.az2
  tags = { Name = "db-az2" }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-gw" }
}

# NAT Gateway - pour que le backend accède à internet
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.dashboard_az1.id   # dans le subnet public
  tags = { Name = "nat-gateway" }
  depends_on = [aws_internet_gateway.gw]
}

# Route table publique
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "public-rt" }
}

# Route table privée → via NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "private-rt" }
}

# Association subnets publics
resource "aws_route_table_association" "dashboard_az1" {
  subnet_id      = aws_subnet.dashboard_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "dashboard_az2" {
  subnet_id      = aws_subnet.dashboard_az2.id
  route_table_id = aws_route_table.public.id
}

# Association subnets privés → NAT Gateway
resource "aws_route_table_association" "backend_az1" {
  subnet_id      = aws_subnet.backend_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "backend_az2" {
  subnet_id      = aws_subnet.backend_az2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_az1" {
  subnet_id      = aws_subnet.db_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_az2" {
  subnet_id      = aws_subnet.db_az2.id
  route_table_id = aws_route_table.private.id
}
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "labvpc"
  }
}

# Declare the data source
data "aws_availability_zones" "zones" {
  state = "available"
}

# Creat public subnets in the first two availability zones
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

# Creat private subnets in the first two availability zones
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
} 

resource "aws_db_subnet_group" "rds_subnet" {
  name       = "db_subnet"
  subnet_ids = aws_subnet.private_subnets.*.id

  tags = {
    Name = "dbsubnet"
  }
}

resource "aws_security_group" "bastion-sg" {
  name = "bastion-sg"
  description = "Allow SSH Login"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
   Name  = "bastion-sg"
 }
}
 
resource "aws_security_group" "front_end-sg" {
  name        = "frontend-sg"
  description = "Allow HTTP requests"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from anywhere"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_frontend-sg.id]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend_sg"
  }
}

resource "aws_security_group" "back_end-sg" {
  name        = "backend-sg"
  description = "Allow HTTP requests"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from anywhere"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_backend-sg.id]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend_sg"
  }
}

resource "aws_security_group" "alb_frontend-sg" {
  name = "alb_frontend-sg"
  description = "Allow HTTP requests"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_frontend-sg"
  }
}

resource "aws_security_group" "alb_backend-sg" {
  name = "alb_backend-sg"
  description = "Allow HTTP requests"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_frontend-sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_backend-sg"
  }
}
 

# Database Security Group
resource "aws_security_group" "database-sg" {
  name        = "DB connection"
  description = "Allow inbound traffic from backend"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow traffic from backend"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.back_end-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "database_sg"
  }
} 


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "nat-gateway"
  }
}

#Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc   = true
  count = 1
  tags = {
    Name  = "nat_eip"
  }
}

# Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rtb"
  }
}

# Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private-rtb"
  }
}

# Associate the public subnets with the public rtb
resource "aws_route_table_association" "public_subnet_rtb_associate" {
  count          = length(aws_subnet.public_subnets[*].id)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate the private subnets with the private rtb
resource "aws_route_table_association" "private_subnet_rtb_associate" {
  count          = length(aws_subnet.private_subnets[*].id)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

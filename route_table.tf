#Elastic IP
resource "aws_eip" "gw" {
    tags = {
        Name = "${var.layer}-${var.stack_id}-elastic"
    }
}

# IGW for the public subnet
resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = aws_vpc.main.id
  tags = {
      Name = "${var.layer}-${var.stack_id}-vpc-ig"
  }
}

resource "aws_nat_gateway" "vpc_nat_gw" {
  subnet_id     = aws_subnet.public1.id
  allocation_id = aws_eip.gw.id
  tags = {
      Name = "${var.layer}-${var.stack_id}-natgatway"
  }
}

# Create a new route table for the private subnets
# And make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "vpc_public_subnet1_routing_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
  }

  tags = {
      Name = "${var.layer}-${var.stack_id}-public_subnet1_routing_table"
  }
}

resource "aws_route_table" "vpc_public_subnet2_routing_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
  }

  tags = {
      Name = "${var.layer}-${var.stack_id}-public_subnet2_routing_table"
  }
}

resource "aws_route_table" "vpc_private_subnet1_routing_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc_nat_gw.id
  }

  tags = {
      Name = "${var.layer}-${var.stack_id}-vpc_private_subnet1_routing_table"
  }
}

resource "aws_route_table" "vpc_private_subnet2_routing_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc_nat_gw.id
  }

  tags = {
      Name = "${var.layer}-${var.stack_id}-vpc_private_subnet2_routing_table"
  }
}

# Explicitely associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "vpc_public_subnet1_routing_table_association" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.vpc_public_subnet1_routing_table.id
}

resource "aws_route_table_association" "vpc_public_subnet2_routing_table_association" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.vpc_public_subnet2_routing_table.id
}

resource "aws_route_table_association" "vpc_private_subnet1_routing_table_association" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.vpc_private_subnet1_routing_table.id
}

resource "aws_route_table_association" "vpc_private_subnet2_routing_table_association" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.vpc_private_subnet2_routing_table.id
}
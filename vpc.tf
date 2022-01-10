resource "aws_vpc" "webapp_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "3_Tier_App"
  }
}

resource "aws_subnet" "web_app_subnet_a" {
  vpc_id                  = aws_vpc.webapp_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-Web-subnet1"
  }
}

resource "aws_subnet" "web_app_subnet_b" {
  vpc_id                  = aws_vpc.webapp_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-Web-subnet2"
  }
}

resource "aws_subnet" "application_subnet_a" {
  vpc_id                  = aws_vpc.webapp_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2a"
  #map_public_ip_on_launch = true

  tags = {
    Name = "private-app-subnet1"
  }
}

resource "aws_subnet" "application_subnet_b" {
  vpc_id                  = aws_vpc.webapp_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-west-2b"
  #map_public_ip_on_launch = true

  tags = {
    Name = "private-app-subnet2"
  }
}

resource "aws_subnet" "database_subnet_a" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "private-Database-subnet1"
  }
}

resource "aws_subnet" "database_subnet_b" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private-Database-subnet2"
  }
}


resource "aws_route_table" "webapp_subnet_route_table" {
  vpc_id = aws_vpc.webapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet.id
    }
    
  tags = {
    Name = "webapp-subnet-route-table"
  }
}

resource "aws_route_table_association" "webapp_subnet_association_a" {
  route_table_id = aws_route_table.webapp_subnet_route_table.id
  subnet_id      = aws_subnet.web_app_subnet_a.id
}

resource "aws_route_table_association" "webapp-subnet-association-b" {
  route_table_id = aws_route_table.webapp_subnet_route_table.id
  subnet_id      = aws_subnet.web_app_subnet_b.id
}


resource "aws_internet_gateway" "internet" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name =  "3TierApp-IGW"
  }
}

resource "aws_eip" "nat_elasticIP_a" {
  vpc = "true"
#  depends_on = [aws_internet_gateway.internet]
}

resource "aws_eip" "nat_elasticIP_b" {
  vpc = "true"
#  depends_on = [aws_internet_gateway.internet]
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_elasticIP_a.id
  subnet_id     = aws_subnet.web_app_subnet_a.id
  tags = {
    Name = "nat-a"
  }
}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_elasticIP_b.id
  subnet_id     = aws_subnet.web_app_subnet_b.id
  tags = {
    Name = "nat-b"
  }
}

resource "aws_route_table" "subnet_route_table_a" {
  vpc_id = aws_vpc.webapp_vpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }
  tags = {
    Name = "subnet-route-table-a"
  }
}

resource "aws_route_table" "subnet_route_table_b" {
  vpc_id = aws_vpc.webapp_vpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_b.id
  }
  tags = {
    Name = "subnet-route-table-b"
  }
}

resource "aws_route_table_association" "api_subnet_assocation_a" {
  
  route_table_id = aws_route_table.subnet_route_table_a.id
  subnet_id      = aws_subnet.application_subnet_a.id
}

resource "aws_route_table_association" "api_subnet_assocation_b" {
  
  route_table_id = aws_route_table.subnet_route_table_b.id
  subnet_id      = aws_subnet.application_subnet_b.id
}

resource "aws_route_table_association" "database_subnet_assocation_a" {
  
  route_table_id = aws_route_table.subnet_route_table_a.id
  subnet_id      = aws_subnet.database_subnet_a.id
}

resource "aws_route_table_association" "database_subnet_assocation_b" {
  
  route_table_id = aws_route_table.subnet_route_table_b.id
  subnet_id      = aws_subnet.database_subnet_b.id
}
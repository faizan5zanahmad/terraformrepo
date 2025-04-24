
resource "aws_vpc" "cust_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cust-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cust_vpc.id

  tags = {
    Name = "cust-igw"
  }
}

resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.cust_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "pub-subnet"
  }
}

resource "aws_subnet" "pvt_subnet" {
  vpc_id            = aws_vpc.cust_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pvt-subnet"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.cust_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-RT"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "Eip-nat"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet.id

  tags = {
    Name = "nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.cust_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "pvt-rt"
  }
}

resource "aws_route_table_association" "pvt_assoc" {
  subnet_id      = aws_subnet.pvt_subnet.id
  route_table_id = aws_route_table.pvt_rt.id
}

resource "aws_key_pair" "demo_key" {
  key_name   = "demo_key"
  public_key = file("c:/Users/Asus Pc/.ssh/id_ed25519.pub")

}




resource "aws_instance" "public_ec2" {
  ami                         = "ami-0f1dcc636b69a6438"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pub_subnet.id
  key_name                    = aws_key_pair.demo_key.key_name
  associate_public_ip_address = true
  tags = {
    Name = "Public-Server"
  }
}

data "aws_internet_gateway" "this" {
  internet_gateway_id = "igw-02d15f4f5b5353d97"
}

resource "aws_route_table" "example" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.this.id
  }

  tags = {
    Name = "main_route_table"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = data.aws_vpc.main.id
  cidr_block        = "172.31.101.0/25"
  availability_zone = "us-east-1a"
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  domain   = "vpc"
}

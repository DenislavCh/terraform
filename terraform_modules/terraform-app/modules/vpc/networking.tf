resource "aws_vpc" "task" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.tenancy}"
  
}

resource "aws_subnet" "task" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${var.subnet_cidr}"

  tags = {
    Name = "task"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.task.id

  tags = {
    Name = "task"
  }
}

resource "aws_default_route_table" "task" {
  default_route_table_id = aws_vpc.task.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "task"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "allow_http"
  vpc_id      = aws_vpc.task.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["85.196.135.202/32"]
    
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

ingress {
    description      = "ICMP"
    from_port       = -1
    to_port         = -1
    protocol         = "icmp"
    cidr_blocks      = ["85.196.135.202/32"]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
output "vpc_id" {
  value = "${aws_vpc.task.id}"
}

output "subnet_id" {
  value = "${aws_subnet.task.id}"
}

output "security_group" {
  value = "${aws_security_group.allow_http.id}"
}

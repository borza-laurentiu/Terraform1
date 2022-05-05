provider "aws" {
  region     = "eu-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "DemoVPC" { //this emulates the creation of a VPC in AWS console
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.name}.tf.vpc" //setting the name of the VPC
  }
}

resource "aws_internet_gateway" "DemoIG" { //internet gateway
  vpc_id = aws_vpc.DemoVPC.id
  tags = {
    Name = "${var.name}.tg.igw"
  }
}

resource "aws_subnet" "DemoPublicSubnet" { //create the subnet
  vpc_id                  = aws_vpc.DemoVPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}.tf.public.subnet"
  }
}

# resource "aws_subnet" "DemoPrivateSubnet" {
#     vpc_id = aws_vpc.DemoVPC.id
#     cidr_block = "10.0.2.0/24"
#     availability_zone = "eu-west-2a"
#     map_public_ip_on_launch = false

#     tags = {
#         Name = "${var.name}.tf.private.subnet"
#     }
# }

resource "aws_security_group" "sgPublic" { // in the application layer
  name        = "app-sg"
  description = "public access"
  vpc_id      = aws_vpc.DemoVPC.id

  ingress { //http access
    description = "allow traffic from port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { //ssh access
    description = "allow traffic from port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "DemoRouteTable" {
  vpc_id = aws_vpc.DemoVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.DemoIG.id
  }

  tags = {
    Name = "${var.name}.tf.routeTable"
  }
}

resource "aws_route_table_association" "publicSubAssoc" { //associate it with the public subnet
  subnet_id      = aws_subnet.DemoPublicSubnet.id
  route_table_id = aws_route_table.DemoRouteTable.id

}

resource "aws_instance" "TestMachine" {
  ami                      = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = var.ssh_key
  subnet_id                   = aws_subnet.DemoPublicSubnet.id
  vpc_security_group_ids       = [aws_security_group.sgPublic.id]
  associate_public_ip_address = true       //to be able to access our instance via SSH

  tags = {
    Name = "${var.name}.tf.TestMachine"
  }
}
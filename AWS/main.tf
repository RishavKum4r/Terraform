# Create a VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.119.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "Developement"
    Owner       = "Rishav"
  }
}

resource "aws_subnet" "dev_public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.119.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Environment = "Developement"
    Owner       = "Rishav"
  }
}

resource "aws_internet_gateway" "dev_ig" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Environment = "Developement"
    Owner       = "Rishav"
  }
}

resource "aws_route_table" "dev_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Environment = "Developement"
    Owner       = "Rishav"
  }

}

resource "aws_route" "dev_route" {
  route_table_id         = aws_route_table.dev_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_ig.id

}

resource "aws_route_table_association" "dev_rta" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev_rt.id

}

resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "dev_key" {
  key_name   = "devkey"
  public_key = file("~/.ssh/awsdevlnxkey.pub")

}

resource "aws_instance" "dev_vm" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.dev_key.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  subnet_id              = aws_subnet.dev_public_subnet.id
  user_data = file("Userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Environment = "Developement"
    Owner       = "Rishav"
  }

}
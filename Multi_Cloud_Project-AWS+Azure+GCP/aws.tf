resource "aws_vpc" "BITS-Project-AWS-VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Sample-Project"
  }
}

resource "aws_internet_gateway" "BITS-Project-AWS-internet-gateway" {
  vpc_id = aws_vpc.BITS-Project-AWS-VPC.id

  tags = {
    Name = "Sample-IGW"
  }
}

resource "aws_subnet" "BITS-Project-AWS-Subnet" {
  vpc_id                  = aws_vpc.BITS-Project-AWS-VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Sample-Subnet"
  }
}

resource "aws_security_group" "BITS-Project-AWS-SG" {
  name        = "BITS-Sample-SG"
  description = "This is a sample Sec Group for demo"
  vpc_id      = aws_vpc.BITS-Project-AWS-VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "BITS-Project-AWS-KP" {
  key_name   = "Sample_key"
  public_key = file("~/.ssh/awsdevlnxkey.pub")
}

resource "aws_instance" "BITS-Project-AWS-Instance" {
  ami           = "ami-00448a337adc93c05"
  instance_type = "t3.small"

  subnet_id = aws_subnet.BITS-Project-AWS-Subnet.id

  vpc_security_group_ids = [aws_security_group.BITS-Project-AWS-SG.id]

  key_name = aws_key_pair.BITS-Project-AWS-KP.key_name

  tags = {
    Name = "BITS-Sample-Instance"
  }
}
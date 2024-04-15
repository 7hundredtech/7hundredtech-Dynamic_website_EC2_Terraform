# Hold all AZs in Region
data "aws_availability_zones" "available_zones" {}
# Create default VPC - if one doesn't exist
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "default_vpc"
  }
}
# Create default Subnet - if one doesn't exist
resource "aws_default_subnet" "default_az" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  tags = {
    Name = "default_subnet"
  }
}
# EC2 Security Group
resource "aws_security_group" "website_sg" {
  name        = "website_sg"
  description = "website security group"
  vpc_id      = aws_default_vpc.default_vpc.id

  # Allow ssh (Port 22)
  ingress {
    description = "Allow access through port 22"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow HTTP access  (Port 80)
  ingress {
    description = "Allow access through port 443"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "website_sg"
  }
}

# Launch EC2 Instance for the website server
resource "aws_instance" "website" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az.id
  vpc_security_group_ids = [aws_security_group.website_sg.id]
  key_name               = "ec2_key"
  user_data              = <<EOF

#!/bin/bash
sudo su
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
cd /var/www/html
wget https://github.com/7hundredtech/E-Commerce/raw/main/E-Commerce.zip
unzip E-Commerce.zip
cp -r furni-1.0.0/* /var/www/html/
rm -rf furni-1.0.0 E-Commerce.zip
EOF

  tags = {
    Name = "website_server"
  }
}
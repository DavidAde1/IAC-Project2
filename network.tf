#VPC
resource "aws_default_vpc" "default" {
  
  tags = {
    Name = "myserver-vpc"
  }
}

# Public subnetss
resource "aws_default_subnet" "public-subnet-1" { 
  tags = {
    Name = "public-subnet-1"
  }
  availability_zone = var.availability_zones[0]
}
resource "aws_default_subnet" "public-subnet-2" { 
  tags = {
    Name = "public-subnet-2"
  }
  availability_zone = var.availability_zones[1]
}
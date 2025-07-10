resource "aws_vpc" "kkVPC" {
  cidr_block        = var.vpc_cidr
  instance_tenancy  = "default"

  tags              = {
    Name            = "kkVPC"
    Project         = "kk_tf_demo"
  }
}

resource "aws_internet_gateway" "kkIGW" {
  vpc_id            = aws_vpc.kkVPC.id

  tags              = {
    Name            = "kkIGW"
    Project         = "kk_tf_demo"
  }
}

resource "aws_eip" "kkNatGatewayEIP1" {
  tags              = {
    Name            = "kkNatGatewayEIP1"
    Project         = "kk_tf_demo"
  }
}

resource "aws_nat_gateway" "kkNatGateway1" {
  allocation_id     = aws_eip.kkNatGatewayEIP1.id
  subnet_id         = aws_subnet.kkPublicSubnet1.id

  tags              = {
    Name            = "kkNatGateway1"
    Project         = "kk_tf_demo"
  }
}

resource "aws_subnet" "kkPublicSubnet1" {
  vpc_id            = aws_vpc.kkVPC.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags              = {
    Name            = "kkPublicSubnet1"
    Project         = "kk_tf_demo"
  }
}

resource "aws_eip" "kkNatGatewayEIP2" {
  tags              = {
    Name            = "kkNatGatewayEIP2"
    Project         = "kk_tf_demo"
  }
}

resource "aws_nat_gateway" "kkNatGateway2" {
  allocation_id     = aws_eip.kkNatGatewayEIP2.id
  subnet_id         = aws_subnet.kkPublicSubnet2.id

  tags              = {
    Name            = "kkNatGateway2"
    Project         = "kk_tf_demo"
  }
}

resource "aws_subnet" "kkPublicSubnet2" {
  vpc_id            = aws_vpc.kkVPC.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags              = {
    Name            = "kkPublicSubnet2"
    Project         = "kk_tf_demo"
  }
}

resource "aws_subnet" "kkPrivateSubnet1" {
  vpc_id            = aws_vpc.kkVPC.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags              = {
    Name            = "kkPrivateSubnet1"
    Project         = "kk_tf_demo"
  }
}

resource "aws_subnet" "kkPrivateSubnet2" {
  vpc_id            = aws_vpc.kkVPC.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags              = {
    Name            = "kkPrivateSubnet2"
    Project         = "kk_tf_demo"
  }
}

resource "aws_route_table" "kkPublicRT" {
  vpc_id            = aws_vpc.kkVPC.id
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.kkIGW.id
  }

  tags              = {
    Name            = "kkPublicRT"
    Project         = "kk_tf_demo"
  }
}

resource "aws_route_table" "kkPrivateRT1" {
  vpc_id            = aws_vpc.kkVPC.id
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.kkNatGateway1.id
  }

  tags              = {
    Name            = "kkPrivateRT1"
    Project         = "kk_tf_demo"
  }
}

resource "aws_route_table" "kkPrivateRT2" {
  vpc_id            = aws_vpc.kkVPC.id
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.kkNatGateway2.id
  }

  tags              = {
    Name            = "kkPrivateRT2"
    Project         = "kk_tf_demo"
  }
}

resource "aws_route_table_association" "kkPublicRTassociation1" {
  subnet_id         = aws_subnet.kkPublicSubnet1.id
  route_table_id    = aws_route_table.kkPublicRT.id
}

resource "aws_route_table_association" "kkPublicRTassociation2" {
  subnet_id         = aws_subnet.kkPublicSubnet2.id
  route_table_id    = aws_route_table.kkPublicRT.id
}

resource "aws_route_table_association" "kkPrivateRTassociation1" {
  subnet_id         = aws_subnet.kkPrivateSubnet1.id
  route_table_id    = aws_route_table.kkPrivateRT1.id
}

resource "aws_route_table_association" "kkPrivateRTassociation2" {
  subnet_id         = aws_subnet.kkPrivateSubnet2.id
  route_table_id    = aws_route_table.kkPrivateRT2.id
}

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "openapp-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_eip" "nat_gw" {
  count = var.single_nat_gw ? 1 : length(var.az_list)
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.single_nat_gw ? 1 : length(var.az_list)
  allocation_id = aws_eip.nat_gw.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}


resource "aws_subnet" "public_subnet" {
  count                   = length(var.az_list)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = var.az_list[count.index]
  tags = merge(
    map(
      "Name", "public_subnet"
    )
  )
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

# Private Subnets
resource "aws_route_table" "private_rt" {
  count = length(aws_nat_gateway.nat_gw)

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.*.id[count.index]
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.az_list)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 2, count.index + 1)
  map_public_ip_on_launch = false
  availability_zone       = var.az_list[count.index]
  tags = merge(
    map(
      "Name", "private_subnet"
    )
  )
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = var.single_nat_gw ? aws_route_table.private_rt.*.id[0] : aws_route_table.private_rt.*.id[count.index]
}
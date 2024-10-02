resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = var.myvpc_id
  availability_zone       = each.value.availability_zone
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}


resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id                  = var.myvpc_id
  availability_zone       = each.value.availability_zone
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false

  tags = {
    Name = each.key
  }
}

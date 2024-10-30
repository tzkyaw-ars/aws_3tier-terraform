resource "aws_eip" "nat_ip" {
  count      = length(aws_subnet.public_subnets)
  depends_on = [aws_internet_gateway.igw]
  tags = {
    "Name" = "nat_ip_${count.index + 1}"
  }
}
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.sandbox_vpc.id}"
  tags = {
    Name = "Internet GW"
  }
}

/* VPC for CHOP's Sandbox account */
resource "aws_vpc" "sandbox_vpc" {
    cidr_block = "${var.sandbox_vpc_cidr_block}"
    tags {
        Name = "Sandbox"
    }
}


/* Public subnet */
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.sandbox_vpc.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.default"]
  tags = {
    Name = "az2-Public"
  }
}

/* Private subnet */
resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.sandbox_vpc.id}"
  cidr_block              = "${var.private_subnet_cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  depends_on              = ["aws_nat_gateway.private"]
  tags {
    Name = "az2-Private"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.sandbox_vpc.id}"
  tags {
    Name = "Private"
  }
}

/* Route from private subnet to NAT gateway,
which is of course below the implied local VPC route -- no import -- */
resource "aws_route" "private" {
  route_table_id         = "${aws_route_table.private.id}"
  nat_gateway_id         = "${aws_nat_gateway.private.id}"
  destination_cidr_block = "0.0.0.0/0"
}

/* Associate the routing table to private subnet -- no import -- */
resource "aws_route_table_association" "private" {
  route_table_id = "${aws_route_table.private.id}"
  subnet_id      = "${aws_subnet.private.id}"
}

/* Associate the routing table to VPC as default "main" */
resource "aws_main_route_table_association" "private" {
  route_table_id = "${aws_route_table.private.id}"
  vpc_id         = "${aws_vpc.sandbox_vpc.id}"
}

/* NAT gateway for egress from the private subnet,
placed in the public subnet */
resource "aws_nat_gateway" "private" {
  allocation_id = "${aws_eip.private.id}"
  subnet_id     = "${aws_subnet.public.id}"
  depends_on    = ["aws_internet_gateway.default"]
}

/* Elastic IP for the NAT Gateway */
resource "aws_eip" "private" {
  vpc               = true
  network_interface = "${aws_network_interface.private.id}"
}

/* Network interface for the NAT gateway */
resource "aws_network_interface" "private" {
  subnet_id         = "${aws_subnet.public.id}"
  source_dest_check = false
  description       = "Interface for NAT Gateway nat-0fd10e8d04d53d50e"
}

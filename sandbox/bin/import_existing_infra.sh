#!/bin/bash

# CHOP's Sandbox VPC
terraform import aws_vpc.sandbox_vpc vpc-d89716bc

# Internet Gateway
terraform import aws_internet_gateway.default igw-0006ff67

# Public Subnets
terraform import aws_subnet.public subnet-68659d45

# Private Subnets
terraform import aws_subnet.private subnet-5cebeb77

# Route Table
terraform import aws_route_table.private rtb-c8dfacac

# NAT Gateway
terraform import aws_nat_gateway.private nat-0fd10e8d04d53d50e

# Private Gateway EIP
terraform import aws_eip.private eipalloc-cd3444fc

# Route Table Assc

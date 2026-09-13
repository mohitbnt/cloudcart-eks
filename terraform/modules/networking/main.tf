# --------------------------------------------------------------------------------
# 1. Create VPC
# --------------------------------------------------------------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}
# --------------------------------------------------------------------------------
# 2. Create public subnets
# --------------------------------------------------------------------------------

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name                     = "${var.project_name}-public-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.project_name}-eks-cluster" = "shared"
  })
}

# --------------------------------------------------------------------------------
# 3. Create private subnets
# --------------------------------------------------------------------------------

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name                              = "${var.project_name}-private-subnet-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

# --------------------------------------------------------------------------------
# 4. Create Internet Gateway
# --------------------------------------------------------------------------------

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

# --------------------------------------------------------------------------------
# 5. Create public route table
# --------------------------------------------------------------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-route-table"
  })
}

# --------------------------------------------------------------------------------
# 6. Create public route
# --------------------------------------------------------------------------------

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

# --------------------------------------------------------------------------------
# 7. Associate public route table with public subnets
# --------------------------------------------------------------------------------

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# --------------------------------------------------------------------------------
# 8. Create private route table
# --------------------------------------------------------------------------------

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-route-table"
  })
}

# --------------------------------------------------------------------------------
# 9. Associate private route table with private subnets
# --------------------------------------------------------------------------------

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# --------------------------------------------------------------------------------
# 10. Create S3 VPC endpoint
# --------------------------------------------------------------------------------

resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_route_table.id]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-s3-vpc-endpoint"
  })
}

# --------------------------------------------------------------------------------
# 11. Create Interface VPC endpoint for SSM and other services
# --------------------------------------------------------------------------------

resource "aws_vpc_endpoint" "interface_vpc_endpoint" {
  vpc_id              = aws_vpc.main_vpc.id
  for_each            = local.interface_endpoints
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [var.vpc_endpoint_sg_id]
  subnet_ids          = aws_subnet.private_subnets[*].id
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${each.key}-vpc-endpoint"
  })
}

# --------------------------------------------------------------------------------
#                   Optional: NAT Gateway for bootstrapping
# --------------------------------------------------------------------------------

# --------------------------------------------------------------------------------
# 12. Elastic IP for NAT Gateway (Created only if enable_nat_gateway = true)
# --------------------------------------------------------------------------------

resource "aws_eip" "nat_gw_eip" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat-gw-eip"
  })
}

# --------------------------------------------------------------------------------
# 13. NAT Gateway (Created only if enable_nat_gateway = true)
# --------------------------------------------------------------------------------

resource "aws_nat_gateway" "nat_gw" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_gw_eip[0].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat-gw"
  })

  depends_on = [
    aws_internet_gateway.main_igw
  ]
}

# --------------------------------------------------------------------------------
# 14. Route to NAT Gateway for Private Route Table
# --------------------------------------------------------------------------------

resource "aws_route" "private_nat_gateway" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
}
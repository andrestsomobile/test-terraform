
### Network

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
      Name = "${var.layer}-${var.stack_id}-vpc"
  }
}
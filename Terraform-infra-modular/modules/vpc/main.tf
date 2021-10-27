# @component CalcApp:VPC (#vpc)
resource "aws_vpc" "cyber94_calculator2_asaleh_vpc_tf" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "cyber94_calculator2_asaleh_vpc"
    }
}

resource "aws_internet_gateway" "cyber94_calculator2_asaleh_ig_tf" {
  vpc_id = aws_vpc.cyber94_calculator2_asaleh_vpc_tf.id

  tags = {
    Name = "cyber94_nginx_asaleh_igw"
  }
}

resource "aws_route_table" "cyber94_calculator2_asaleh_internet_rt_tf" {
    vpc_id = aws_vpc.cyber94_calculator2_asaleh_vpc_tf.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.cyber94_calculator2_asaleh_ig_tf.id
    }
}

resource "aws_route53_zone" "cyber94_calculator2_asaleh_vpc_dns_tf" {
  name = "cyber94-abdul.sparta"

  vpc {
    vpc_id = aws_vpc.cyber94_calculator2_asaleh_vpc_tf.id
  }
}

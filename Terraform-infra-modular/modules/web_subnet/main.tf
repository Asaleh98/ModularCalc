# @component CalcApp:VPC:Subnet(#subnet)
resource "aws_subnet" "cyber94_calculator2_asaleh_subnet_tf" {
    vpc_id = var.var_aws_vpc_id
    cidr_block = "10.0.1.0/24"

    tags = {
      Name = "cyber94_calculator2_asaleh_subnet"
    }
}

resource "aws_route_table_association" "cyber94_calculator2_asaleh_subnet_web_assoc_tf" {
    subnet_id = aws_subnet.cyber94_calculator2_asaleh_subnet_tf.id
    route_table_id = var.var_internet_route_table
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "cyber94_nginx_asaleh_vpc_tf"{
  cidr_block ="10.101.0.0/16"

  tags ={
    Name = "cyber94_nginx_asaleh_vpc"
  }
}

resource "aws_internet_gateway" "cyber94_nginx_asaleh_igw_tf" {
    vpc_id = aws_vpc.cyber94_nginx_asaleh_vpc_tf.id

    tags ={
      Name = "aws_internet_gateway.cyber94_nginx_asaleh_igw"
    }
}

resource "aws_route_table" "cyber94_nginx_asaleh_rt_tf" {
  vpc_id = aws_vpc.cyber94_nginx_asaleh_vpc_tf.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cyber94_nginx_asaleh_igw_tf.id
  }

  tags = {
    Name = "cyber94_nginx_asaleh_internet_rt"
  }
}

resource "aws_subnet" "cyber94_nginx_asaleh_subnet_app_tf" {
  vpc_id = aws_vpc.cyber94_nginx_asaleh_vpc_tf.id
  cidr_block = "10.101.1.0/24"

  tags = {
    Name = "cyber94_nginx_asaleh_subnet_app"
  }
}

resource "aws_route_table_association" "cyber94_nginx_asaleh_internet_rt_assoc_app_tf" {
    subnet_id = aws_subnet.cyber94_nginx_asaleh_subnet_app_tf.id
    route_table_id = aws_route_table.cyber94_nginx_asaleh_rt_tf.id
}

resource "aws_security_group" "cyber94_nginx_asaleh_sg_server_public_tf" {
    name = "cyber94_nginx_asaleh_sg_server_public"

    vpc_id = aws_vpc.cyber94_nginx_asaleh_vpc_tf.id

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
      Name = "cyber94_nginx_asaleh_sg_server_public"
    }
}

resource "aws_network_acl" "cyber94_nginx_asaleh_nacl_app_tf" {
    vpc_id = aws_vpc.cyber94_nginx_asaleh_vpc_tf.id
    subnet_ids = [aws_subnet.cyber94_nginx_asaleh_subnet_app_tf.id]
    egress {
      protocol   = "-1"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
    egress {
      protocol   = "-1"
      rule_no    = 200
      action     = "deny"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }

    ingress {
      protocol   = "-1"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
    ingress {
      protocol   = "-1"
      rule_no    = 200
      action     = "deny"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
    tags = {
      Name = "cyber94_nginx_asaleh_nacl_app"
    }
}
resource "aws_instance" "cyber94_nginx_asaleh_server_proxy_tf" {
    ami = "ami-0943382e114f188e8"
    instance_type = "t2.micro"
    key_name = "cyber94-asaleh"
    subnet_id = aws_subnet.cyber94_nginx_asaleh_subnet_app_tf.id
    vpc_security_group_ids = [aws_security_group.cyber94_nginx_asaleh_sg_server_public_tf.id]
    associate_public_ip_address = true

    tags = {
      Name = "cyber94_nginx_asaleh_server_proxy_app"
    }

    lifecycle {
      create_before_destroy = true
    }
  }

  resource "aws_instance" "cyber94_nginx_asaleh_server_app1_tf" {
      ami = "ami-0943382e114f188e8"
      instance_type = "t2.micro"
      key_name = "cyber94-asaleh"
      subnet_id = aws_subnet.cyber94_nginx_asaleh_subnet_app_tf.id
      vpc_security_group_ids = [aws_security_group.cyber94_nginx_asaleh_sg_server_public_tf.id]
      associate_public_ip_address = true

      tags = {
        Name = "cyber94_nginx_asaleh_server_app1_app"
      }

      lifecycle {
        create_before_destroy = true
      }
    }

    resource "aws_instance" "cyber94_nginx_asaleh_server_app2_tf" {
        ami = "ami-0943382e114f188e8"
        instance_type = "t2.micro"
        key_name = "cyber94-asaleh"
        subnet_id = aws_subnet.cyber94_nginx_asaleh_subnet_app_tf.id
        vpc_security_group_ids = [aws_security_group.cyber94_nginx_asaleh_sg_server_public_tf.id]
        associate_public_ip_address = true

        tags = {
          Name = "cyber94_nginx_asaleh_server_app2_app"
        }

        lifecycle {
          create_before_destroy = true
        }
      }

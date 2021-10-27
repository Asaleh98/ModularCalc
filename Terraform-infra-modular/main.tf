provider "aws" {
  region = var.var_region
}

module "vpc" {
  source = "./modules/vpc"
}

module "web_subnet" {
  source = "./modules/web_subnet"
  var_dns_zone_id = module.vpc.output_dns_zone_id
  var_aws_vpc_id = module.vpc.output_aws_vpc_id
  var_internet_route_table = module.vpc.output_internet_route_table
}

module "webserver" {
  source = "./modules/webserver"
  var_web_subnet_id = module.web_subnet.output_web_subnet_id
  var_ssh_key_name = var.var_ssh_key_name
  var_dns_zone_id = module.vpc.output_dns_zone_id

  var_aws_vpc_id = module.vpc.output_aws_vpc_id
}

/*module "backend" {
  source = "./modules/backend"
  var_aws_bucket_id= module.backend.output_aws_bucket_id
}
*/
resource "aws_dynamodb_table" "cyber94_fullinfra_asaleh_dynamodb_table_lock2_tf" {
  name = "cyber94_calculator_asaleh_dynamodb_table_lock2"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

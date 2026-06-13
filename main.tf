module "my_ec2" {
  source = "./modules/ec2"
  ami    = var.ami
}

module "my_s3_bucket" {
  source = "./modules/s3"
}

module "my_dynamodb_table" {
  source = "./modules/dynamodb"
}

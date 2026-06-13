resource "aws_instance" "my_ec2" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = ["default"]
  key_name        = "terrform_india_pam"
  tags = {
    Name = "Rohan_EC2_Instance"
  }
}

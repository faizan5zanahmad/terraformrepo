

resource "aws_instance" "my_ec2" {
  ami           = "ami-0f88e80871fd81e91" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"

  tags = {
    Name = "MyTerraformInstance"
  }
}
#prevent _destroy
# {Prevents accidental destruction of a resource. Terraform will throw an error if a destroy is attempted}
#  resource "aws_s3_bucket" "my_bucket" {
#    bucket = "faizan-important-bucket"

#    lifecycle {
#      prevent_destroy = true
#    }
#  }
#          OUTPUT      Error: Instance cannot be destroyed
# │
# │   on main .tf line 1:
# │    1: resource "aws_s3_bucket" "my_bucket" {
# │
# │ Resource aws_s3_bucket.my_bucket has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and
# │ continue with the plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.

# # 2)  Using create_before_destroy

resource "aws_instance" "web" {
  ami           = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
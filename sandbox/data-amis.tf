/* Default EBS backed Amazon Linux AMI */
data "aws_ami" "default" {
  most_recent = "true"
  owners = ["amazon"]

  filter = {
    name = "name"
    values = ["amzn-ami-hvm*x86_64-gp2"]
  }
}

module "consul" {
  // source  = "github.com/hashicorp/consul/terraform/aws"
  source  = "/Users/riverat2/Projects/consul/terraform/aws"
  servers = 3
  key_path = "${var.key_path}"
  key_name = "${var.key_name}"
}

/* Default security group */
resource "aws_security_group" "default" {
  name = "chop-vault-default"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${aws_vpc.sandbox_vpc.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "chop-vault-default"
    Workgroup   = "dbhi"
    Project     = "vault"
  }
}

resource "aws_instance" "bastion_host" {
    ami = "${data.aws_ami.default.id}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.public.id}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "true"
    vpc_security_group_ids = ["${aws_security_group.default.id}", "${aws_security_group.chop-bastion-default.id}"]

    tags {
        Name = "chop-consul-bastion"
        Workgroup = "dbhi"
    }
}

resource "aws_eip" "bastion_ip" {
  instance = "${aws_instance.bastion_host.id}"
  vpc      = true
}

resource "aws_security_group" "chop-bastion-default" {
    name = "chop-bastion-default"
    description = "Default Bastion Security Group."

    // These are for internal traffic
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["159.14.0.0/16"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

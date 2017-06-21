variable "key_name" {
    default = "DBHiKey"
}

variable "key_path" {
    default = "/Users/riverat2/.ssh/DBHiKey.pem"
}

variable "region" {
    default = "us-east-1"
}

variable "profile" {
    default = "saml"
}


variable "sandbox_vpc_cidr_block" {
    default = "172.31.0.0/16"
}

variable "public_subnet_cidr" {
    default = "172.31.16.0/20"
}

variable "private_subnet_cidr" {
    default = "172.31.48.0/20"
}

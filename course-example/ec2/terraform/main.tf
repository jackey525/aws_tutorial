provider "aws" {
  region = "us-east-1"
}

locals {
  user_data = <<EOF
#!/bin/bash
sudo apt update -y 
sudo apt install -y nginx
sudo apt install -y unzip
sudo systemctl enable nginx
sudo systemctl start nginx
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
EOF
}

##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "terraform-lab"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp","ssh-tcp","all-icmp"]
  egress_rules        = ["all-all"]
}

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count = 1

  name          = "terraform-ec2-lab"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = tolist(data.aws_subnet_ids.all.ids)[0]
  //  private_ips                 = ["172.31.32.5", "172.31.46.20"]
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true
  key_name= "PagiLab-USEAST-1"

  user_data_base64 = base64encode(local.user_data)
}

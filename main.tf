# Configure the AWS Provider
provider "aws" {
  profile ="default"
  region     = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.key_name}"
  public_key = "${var.public_key}"
}

data "aws_security_group" "security_group" {
  id = "${var.security_group}"

}
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "rc-vpc"
  }
}

#deploying an Ec2 instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.small"
  key_name        = "${aws_key_pair.deployer.key_name}"
  security_groups = ["${data.aws_security_group.security_group.name}"]

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 40
  }


  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = "${file(var.private_key)}"
      agent       = true
    }

    inline = [
      "sudo apt update -y",
      "sudo apt upgrade -y",
      "curl -L https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "sudo reboot",
    ]
  }

  tags = {
    Name = "RocketChat"
  }
}


locals {
  this_id         = "${join(",", aws_instance.web.*.id)}"
  this_key_name   = "${join(",", aws_instance.web.*.key_name)}"
  this_public_dns = "${join(",", aws_instance.web.*.public_dns)}"
  this_public_ip  = "${join(",", aws_instance.web.*.public_ip)}"
}

output "id" {
  description = "List of IDs of instances"
  value       = ["${local.this_id}"]
}

output "key_name" {
  description = "List of key names of instances"
  value       = ["${local.this_key_name}"]
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = ["${local.this_public_dns}"]
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = ["${local.this_public_ip}"]
}

resource "aws_security_group" "Rocket_Chat_Security" {
  name        = "Rocket_Chat_Security"
  description = "Allow important inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Rocket_Chat_Security"
  }
}

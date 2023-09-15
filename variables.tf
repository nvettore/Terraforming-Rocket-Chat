variable "key_name" {
  default = "rocketserverkey"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/KynP3hxK/QwZ+3fPoKkvbjQ1fcqN6eeJ7ZUQO1eU5LWxitMjdlizWOUM/rpPHe82iGlexaLgc2XPBs8zY3aoqxZly16uzg7f+9npsqjVPIhQVCW4PBaHjeCrOR3My9okE7UQoZqsRZ2AJ2cYa0OBHG0qB9yCcqbb3A8Bw7r/n7kE/eqcrP2dn0lWpuAuX+bBwgIhIvAnbTTvZogcHw+yzKMjb9TwyDDGdiU2zJlLK7o4qDDQ9f2HFYDwvByv3EiDN/rcmHPF+MoO5OX3Jw80Ts5PXSHr4ViPbq5eJL+6oVkWw12HgOW8xfbxZZA+xH07ZEKMYp+rfZKDL8T43Fwh"
}

#default security group within the aws ec2 instance
variable "security_group" {
  default = "sg-0cfa289c3d40e5003"
}

variable "private_key" {
  default = "/home/nick/Desktop/aws/Terraforming-Rocket-Chat/rocketchat-priv.pem"
}

variable"ami_rocketchat" {
  default = "ami-01fff7811ea402d67"
}

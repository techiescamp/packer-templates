
variable "ami_id" {
  type    = string
  default = "ami-6f68cf0f"
}

locals {
    app_name = "httpd"
}

variable "app_name" {
  type    = string
  default = "httpd"
}

source "amazon-ebs" "httpd" {
  ami_name      = "PACKER-DEMO-${local.app_name}"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  source_ami    = "${var.ami_id}"
  ssh_username  = "ec2-user"
  tags = {
    Env  = "DEMO"
    Name = "PACKER-DEMO-${var.app_name}"
  }
}

build {
  sources = ["source.amazon-ebs.httpd"]

  provisioner "shell" {
    script = "script.sh"
  }

  post-processor "shell-local" {
    inline = ["echo foo"]
  }
}

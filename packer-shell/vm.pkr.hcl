
variable "ami_id" {
  type    = string
  default = "ami-0ca5c3bd5a268e7db"
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
  region        = "us-west-2"
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

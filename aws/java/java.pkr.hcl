variable "ami_id" {
  type    = string
  default = "ami-017fecd1353bcc96e"
}

locals {
    app_name = "pet-clinic-java"
}

source "amazon-ebs" "java" {
  ami_name      = "packer-${local.app_name}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = "${var.ami_id}"
  ssh_username  = "ubuntu"
  tags = {
    Env  = "dev"
    Name = "packer-${local.app_name}"
  }
}

build {
  sources = ["source.amazon-ebs.java"]

  provisioner "file" {
    source = "/Users/bibinwilson/Documents/code/devops-class/vagrant/java/app.jar"
    destination = "/home/ubuntu/deployment/"
  }
  
  provisioner "shell" {
    script = "scripts/java.sh"
  }

  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    }
}

# defining the plugins

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# defining the source block

source "amazon-ebs" "ubuntu-nginx" {
  ami_name      = "ubuntu-nginx"
  instance_type = "t2.micro"
  region        = "us-east-1"
//   vpc_id = "vpc-00e89f2e34c07baab"
//   subnet_id = "subnet-0ea7d6ad6794962db"
  source_ami = "ami-0c7217cdde317cfec"  #using ubuntu latest ami as base
  
  ssh_username = "ubuntu"
}

# defining the build block

build {
  name = "ubuntu-nginx-ami"
  sources = [
    "source.amazon-ebs.ubuntu-nginx"
  ]

# defining the provisioner block

  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo systemctl status nginx",
      "sudo ufw allow proto tcp from any to any port 22,80,443",
      "echo 'y' | sudo ufw enable",
    ]
  }

}




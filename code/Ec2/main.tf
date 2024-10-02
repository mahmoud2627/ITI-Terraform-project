
data "aws_ami" "amz_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

locals {
  public_instances = {
    "proxy_1" = {
      subnet_id      = var.pub_sub1_id
      instance_name  = "proxy_1"
    }
    "proxy_2" = {
      subnet_id      = var.pub_sub2_id
      instance_name  = "proxy_2"
    }
  }

  private_instances = {
    "web1" = {
      subnet_id      = var.priv_sub1_id
      instance_name  = "web1"
      file_source    = "/home/gobar/project/WeB-1/index.html"
    }
    "web2" = {
      subnet_id      = var.priv_sub2_id
      instance_name  = "web2"
      file_source    = "/home/gobar/project/WeB-2/index.html"
    }
  }
}

# Create EC2 instance
resource "aws_instance" "bast_host" {
  ami                         = data.aws_ami.amz_linux.id
  instance_type               = var.ec2type
  associate_public_ip_address  = true
  key_name                    = var.ec2key  

  subnet_id       = var.pub_sub1_id
  security_groups = [var.pub_sg_id]

  tags = {
    Name = "BH"
  }
}


resource "aws_instance" "nginx" {
  for_each                     = local.public_instances
  ami                          = data.aws_ami.amz_linux.id
  instance_type                = var.ec2type
  associate_public_ip_address   = true
  key_name                     = var.ec2key
  subnet_id                    = each.value.subnet_id
  security_groups              = [var.pub_sg_id]

  provisioner "local-exec" {
    command = "echo ${each.value.instance_name} Public IP ${self.public_ip} >> all-ips.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      <<EOF
      echo 'server {
        listen 80;
        location / {
          proxy_pass http://${var.alb_private_dns};
        }
      }' | sudo tee /etc/nginx/conf.d/reverse-proxy.conf
      EOF
      ,"sudo systemctl restart nginx"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/gobar/project/key/mah.key")
    host        = self.public_ip
  }

  tags = {
    Name = each.value.instance_name
  }
}

resource "aws_instance" "web" {
  for_each                     = local.private_instances
  ami                          = data.aws_ami.amz_linux.id
  instance_type                = var.ec2type
  key_name                     = var.ec2key
  subnet_id                    = each.value.subnet_id
  security_groups              = [var.priv_sg_id]

  provisioner "local-exec" {
    command = "echo ${each.value.instance_name} Private IP ${self.private_ip} >> all-ips.txt"
  }

  provisioner "file" {
    source      = each.value.file_source
    destination = "/tmp/index.html"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/gobar/project/key/mah.key")
      host        = self.private_ip
      bastion_host = aws_instance.bast_host.public_ip
      bastion_user = "ec2-user"
      bastion_private_key = file("/home/gobar/project/key/mah.key")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo systemctl restart httpd"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/gobar/project/key/mah.key")
      host        = self.private_ip
      bastion_host = aws_instance.bast_host.public_ip
      bastion_user = "ec2-user"
      bastion_private_key = file("/home/gobar/project/key/mah.key")
    }
  }

  tags = {
    Name = each.value.instance_name
  }
}

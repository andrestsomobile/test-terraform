data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "tls_private_key" "oskey" {
  algorithm = "RSA"
}

resource "local_file" "mykey" {
  content  = tls_private_key.oskey.private_key_pem
  filename = "mykey.pem"
}

resource "aws_key_pair" "key" {
  key_name   = "myterrakey"
  public_key = tls_private_key.oskey.public_key_openssh
}

resource "aws_instance" "example" {
	ami = data.aws_ami.amazon-linux.id
	instance_type = "t2.micro"
  subnet_id = aws_subnet.public1.id
  key_name      = aws_key_pair.key.key_name

  associate_public_ip_address = true

  provisioner "file" {
    source      = "files/package.json"
    destination = "/home/ec2-user/package.json"
       
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.oskey.private_key_pem
      host        = "${self.public_ip}"
    }
  }

  provisioner "file" {
    source      = "files/index.js"
    destination = "/home/ec2-user/index.js"
       
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.oskey.private_key_pem
      host        = "${self.public_ip}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y && sudo yum install -y gcc-c++ make && sudo curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - && sudo yum install -y nodejs  && sed -i -e 's#process.env.RDS_HOSTNAME#${aws_db_instance.default.endpoint}#g' index.js && sed -i -e 's#:3306##g' index.js && npm install && npm run start"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.oskey.private_key_pem
      host        = "${self.public_ip}"
    }
  }
				
	tags = {
		Name = "My first EC2 using Terraform"
	}
	vpc_security_group_ids = [aws_security_group.instance.id]

  depends_on = [
    aws_db_instance.default
  ]
}
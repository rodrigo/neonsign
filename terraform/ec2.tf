data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
   values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "this" {
  ami = data.aws_ami.this.id
  security_groups = [aws_security_group.allow_http.name]
  # instance_market_options {
  #   spot_options {
  #     max_price = 0.0031
  #   }
  # }
  instance_type = "t3.micro"
  tags = {
    Name = "test-spot"
  }
  iam_instance_profile = aws_iam_instance_profile.this.name
  user_data = <<EOF
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
sudo amazon-linux-extras install -y docker
sudo service docker start
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 525726440883.dkr.ecr.us-east-1.amazonaws.com
sudo docker pull ${data.aws_ecr_image.neonsign.image_uri}
sudo docker stop $(docker ps -a -q)
sudo docker run -d -p 80:3000 ${data.aws_ecr_image.neonsign.image_uri}
sudo docker system prune --all --force
--//--
  EOF
}

data "external" "docker_image" {
  program = ["bash", "update_docker_image.sh"]
}

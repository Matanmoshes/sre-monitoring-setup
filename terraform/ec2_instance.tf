#resource "aws_eip" "web_app_eip" {
#  instance = aws_instance.monitoring_instance.id
#  domain   = "vpc"
#  tags = {
#    Name = "web-app-eip"
#  }
#}

#resource "aws_eip_association" "web_app_eip_assoc" {
#  instance_id   = aws_instance.monitoring_instance.id
#  allocation_id = aws_eip.web_app_eip.id
#}

resource "aws_instance" "monitoring_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = var.key_pair_name

  user_data = "${file("user-data-script.sh")}"

  tags = {
    Name = "monitoring-instance"
  }
}

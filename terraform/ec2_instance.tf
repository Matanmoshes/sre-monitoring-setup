resource "aws_instance" "monitoring_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = var.key_pair_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    # Install Docker
    amazon-linux-extras install docker -y
    service docker start
    usermod -a -G docker ec2-user
    # Install Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/2.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    # Clone the repository containing docker-compose.yml
    yum install -y git
    cd /home/ec2-user
    git clone https://github.com/yourusername/yourrepo.git
    chown -R ec2-user:ec2-user yourrepo
    cd yourrepo
    # Start the containers
    docker-compose up -d
  EOF

  tags = {
    Name = "monitoring-instance"
  }
}

resource "aws_instance" "monitoring_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = var.key_pair_name

  user_data = <<-EOF
    #!/bin/bash
    # Update the system
    apt-get update -y

    # Install Git
    apt-get install -y git

    # Change to the ubuntu user's home directory
    cd /home/ubuntu

    # Clone the repository
    git clone https://github.com/Matanmoshes/sre-monitoring-setup.git

    # Change ownership of the cloned repository
    chown -R ubuntu:ubuntu sre-monitoring-setup

    # Change to the repository directory
    cd sre-monitoring-setup

    # Ensure the script has execution permissions
    chmod +x setup.sh

    # Run the script as root
    bash setup.sh

    
  EOF

  tags = {
    Name = "monitoring-instance"
  }
}

resource "aws_security_group" "public_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ✅ SSH Access
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ✅ Prometheus Web UI
  }

  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ✅ Alertmanager
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # ✅ Allow all outbound traffic
  }

  tags = {
    Name = "public-sg"
  }
}

# ✅ Remove private_sg, since no private instances exist.

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}
